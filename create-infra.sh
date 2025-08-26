#!/bin/bash -x

export TF_VAR_token=$(yc iam create-token)
export TF_VAR_cloud_id='b1ge1n8pte02l62mahfr'
export TF_VAR_folder_id='b1gih35rpnn00onvnk09'
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

echo "cloud_id=/"${TF_VAR_cloud_id}/"/nfolder_id=/"${TF_VAR_folder_id}/"/nkey_file=/"${TF_VAR_sa_file_key}/"" > ./bucket/personal.auto.tfvars

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



#if terraform -chdir=infra init -backend-config="access_key=$TF_VAR_static_access_key" -backend-config="secret_key=$TF_VAR_static_secret_key" -backend-config="bucket=$TF_VAR_storage_id"; then
#fi