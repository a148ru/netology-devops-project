#!/bin/bash -x


# Выводит справку
help() {
    echo "Использование: $0 -a <authorized_key.json> -c <cloud_id> -f <folder_id>"
    echo ""
    echo "  -a, --auth-file PATH        Путь к файлу authorized_key.json"
    echo "  -c, --cloud-id VALUE        id облака в Yandex Cloud"
    echo "  -f, --folder-id VALUE       id каталога в Yandex Cloud"
    echo "  -h, --help                  Вывести эту справку"
    exit 1
}

# Обрабатываем аргументов командной строки
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -a|--auth-file) TF_VAR_auth_file="${PWD}/${2}"; shift ;;
        -c|--cloud-id) TF_VAR_cloud_id="$2"; shift ;;
        -f|--folder-id) TF_VAR_folder_id="$2"; shift ;;
        -h|--help) help ;;
        *) echo "Проверь параметры: $1"; help ;;
    esac
    shift
done

# Проверяем переменные

if [ -z $TF_VAR_auth_file ] || [ -z $TF_VAR_cloud_id ] || [ -z $TF_VAR_folder_id ]
then
  echo ""
  echo "Необходимо указать параметры!"
  echo ""
  help
fi


# Экспорт переменных в окружение

#export TF_VAR_token=$(yc iam create-token)
export TF_VAR_cloud_id="${TF_VAR_cloud_id}"
export TF_VAR_folder_id="${TF_VAR_folder_id}"
export TF_VAR_auth_file="${TF_VAR_auth_file}"
export TF_VAR_env_file="$PWD/.env"
export TF_VAR_sa_file_key="$PWD/sa_key.json" 


# Создаем сервисный аккаунт и необходимые ключи

if terraform -chdir=sa init
then
    if terraform -chdir=sa apply -auto-approve
    then
        source $TF_VAR_env_file
    else
     exit -1
    fi
fi

echo "cloud_id=\"${TF_VAR_cloud_id}\"
folder_id=\"${TF_VAR_folder_id}\"
auth_file=\"${TF_VAR_auth_file}\"" > ./bucket/personal.auto.tfvars

# Создаем бакет
if terraform -chdir=bucket init
then
    if terraform -chdir=bucket apply -auto-approve
    then
        source $TF_VAR_env_file
    else
        exit -1
    fi
fi

echo "cloud_id=\"${TF_VAR_cloud_id}\"
folder_id=\"${TF_VAR_folder_id}\"
auth_file=\"${TF_VAR_sa_file_key}\"" > ./infra/personal.auto.tfvars

if terraform -chdir=infra init -backend-config="access_key=$TF_VAR_static_access_key" -backend-config="secret_key=$TF_VAR_static_secret_key" -backend-config="bucket=$TF_VAR_storage_id"
then
    if terraform -chdir=infra apply -auto-approve
    then
      echo "done"
    else
      echo "Смотри ошибки"
      exit -1
    fi
fi