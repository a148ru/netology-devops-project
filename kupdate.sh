#!/bin/bash 

image_name="demo_app"
image_release="0.0.5"


build_image(){

  rm -rfv ./app_demo

  git clone https://github.com/a148ru/app_demo.git

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

build_image

cd monitoring

kubectl apply --server-side -f manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring
kubectl apply -f manifests/
kubectl apply -f ../infra/app/app_demo.yml