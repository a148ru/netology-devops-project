#!/bin/bash

DESTROY=0
image_name="demo_app"
image_release="latest"

# Выводит справку
help() {
    echo "Использование: $0 -a <authorized_key.json> -c <cloud_id> -f <folder_id>"
    echo ""
    echo "  -a, --auth-file PATH        Путь к файлу authorized_key.json"
    echo "  -c, --cloud-id VALUE        id облака в Yandex Cloud"
    echo "  -f, --folder-id VALUE       id каталога в Yandex Cloud"
    echo "  -d, --destroy               Удалить ресурсы"
    echo "  -h, --help                  Вывести эту справку"
    exit 1
}

# Удаляет стейт из бакета
delete_state(){
    if yc storage s3api delete-object --bucket $1 --key $2
    then
      echo "state delete - done"
    else
      echo "state delete - error"
      exit 1
    fi
}

# Создает файл personal.auto.tfvars
# первый пареметр - путь к файлу ключей - абсолютный путь
# второй параметр - целевая дериктория - относительный путь
create_personal_vars(){
    echo "cloud_id=\"${TF_VAR_cloud_id}\"
folder_id=\"${TF_VAR_folder_id}\"
auth_file=\"${1}\"" > ./$2/personal.auto.tfvars
}

# Создает ресурсы
# В параметре указать имя директории относительно текущей или абсалютный путь
create_resource(){
    if terraform -chdir=$1 init
    then
        if terraform -chdir=$1 apply -auto-approve
        then
            source $TF_VAR_env_file
        else
            exit 1
        fi
    fi
}

create_infra(){
    if terraform -chdir=$1 init -backend-config="access_key=$TF_VAR_static_access_key" -backend-config="secret_key=$TF_VAR_static_secret_key" -backend-config="bucket=$TF_VAR_storage_id" -reconfigure
    then
        if terraform -chdir=$1 apply -auto-approve
        then
          echo "done"
        else
          echo "Смотри ошибки"
          exit 1
        fi
    fi
}

apply(){

  # Экспорт переменных в окружение

#export TF_VAR_token=$(yc iam create-token)
export TF_VAR_cloud_id="${TF_VAR_cloud_id}"
export TF_VAR_folder_id="${TF_VAR_folder_id}"
export TF_VAR_auth_file="${TF_VAR_auth_file}"
export TF_VAR_env_file="$PWD/.env"
export TF_VAR_sa_file_key="$PWD/sa_key.json" 

    # Создаем сервисный аккаунт и необходимые ключи
    create_resource "sa"
    create_personal_vars $TF_VAR_auth_file "sa"
    create_personal_vars $TF_VAR_auth_file "bucket"

    # Создаем бакет
    create_resource "bucket"
    create_personal_vars $TF_VAR_sa_file_key "infra"

    create_infra "infra"
}

destroy(){
    source $PWD/.env
    if terraform -chdir=infra destroy -auto-approve
    then
      delete_state $TF_VAR_storage_id "terraform.tfstate"
    else
      exit 1
    fi
    terraform -chdir=bucket destroy -auto-approve
    terraform -chdir=sa destroy -auto-approve
}

build_image(){
  if [ ! -d "app_demo" ];  then
    git clone https://github.com/a148ru/app_demo.git
  fi
  REGISTRY_ENDPOINT="cr.yandex/$(terraform -chdir=infra output -raw registry_endpoint)"
  # REGISTRY_ENDPOINT=${REGISTRY_ENDPOINT//\"/}
  IMAGE="/${image_name}:${image_release}"
  if [ ! -z $REGISTRY_ENDPOINT ];  then
    docker build -t "${REGISTRY_ENDPOINT}${IMAGE}" app_demo
    docker push "${REGISTRY_ENDPOINT}${IMAGE}"
    sed -i "s|image:.*|image: $REGISTRY_ENDPOINT$IMAGE|g" ./infra/app/app_demo.yml

  else
    echo "Registry endpoint don't set - ERORR!!!"
  fi
}

delete_image(){
  registry=$(terraform -chdir=infra output registry_endpoint)
  registry=${registry//\"/}
  image_id=$(yc container image list --folder-id=$TF_VAR_folder_id | grep "${registry}/${image_name}" | awk '{print $2}')
  yc container image delete $image_id
}

# Обрабатываем аргументов командной строки
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -a|--auth-file) file_name="${2}"; shift ;;
        -c|--cloud-id) TF_VAR_cloud_id="$2"; shift ;;
        -f|--folder-id) TF_VAR_folder_id="$2"; shift ;;
        -d|--destroy) DESTROY=1; shift ;;
        -h|--help) help ;;
        *) echo "Проверь параметры: $1"; help ;;
    esac
    shift
done

if [[ "$file_name" == /* ]]; then
    # Если путь абсолютный
    TF_VAR_auth_file="$file_name"
else
    # Если путь относительный
    TF_VAR_auth_file="$(pwd)/$file_name"
fi



# Проверяем переменные

if [ -z $TF_VAR_auth_file ] || [ -z $TF_VAR_cloud_id ] || [ -z $TF_VAR_folder_id ]
then
  echo ""
  echo "Необходимо указать параметры!"
  echo ""
  help
fi

# Проверяем существование файла
if [ ! -f "$TF_VAR_auth_file" ]; then
    echo "Ошибка: файл не найден по пути '$TF_VAR_auth_file'"
    exit 1
fi

if [ $DESTROY -eq 1 ]
then
  delete_image
  destroy

else
  apply
  build_image

  kubectl create ns monitoring

  cd monitoring

  kubectl apply --server-side -f manifests/setup
  kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring
  kubectl apply -f manifests/
  kubectl apply -f ../infra/app/app_demo.yml
fi


