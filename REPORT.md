## Этапы выполнения

### Создание облачной инфраструктуры

Стейт основной конфигурации сохраняется в бакете

![alt text](img/image.png)

```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    region = "ru-central1"
    key    = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.

  }
}
```

### Создание Kubernetes кластера

В качестве кластера kubernetes используется сервис Yandex Managed Service for Kubernetes с региональным мастером и тремя нодами в разных зонах доступности.
![alt text](img/image-1.png)
![alt text](img/image-2.png)
![alt text](img/image-3.png)
![alt text](img/image-4.png)
![alt text](img/image-5.png)

### Создание тестового приложения

Создано тестовое приложение https://github.com/a148ru/app_demo
Собраный docker image хранится в Yandex Container Registry (часть основной инфраструктуры)
![alt text](img/image-6.png)

### Подготовка cистемы мониторинга и деплой приложения

Используется пакет kube-prometheus, собрана конфигурация по умолчанию, после чего внесены изменения в файл сервиса grafana (тип и порт)
grafana-service.yaml
```
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/component: grafana
    app.kubernetes.io/name: grafana
    app.kubernetes.io/part-of: kube-prometheus
    app.kubernetes.io/version: 12.1.0
  name: grafana
  namespace: monitoring
spec:
  ports:
  - name: http
    port: 80
    targetPort: http
  selector:
    app.kubernetes.io/component: grafana
    app.kubernetes.io/name: grafana
    app.kubernetes.io/part-of: kube-prometheus
  type: LoadBalancer
```
Тестовое приложение и grafana доступны по портам 80 с внешними ip-адресами

![80](image-7.png)
![alt text](img/image-10.png)
![alt text](img/image-8.png)
![alt text](img/image-9.png)

Настроен workflow на пуш в ветку main

![alt text](img/image-11.png)


### Установка и настройка CI/CD

для деплоя приложения используется Github Action

#### 1. workflow при коммите в ветку main

![alt text](img/image-12.png)

Отправка в registry

![alt text](img/image-13.png)

#### 2. workflow при создании тега
добавилил тег
![alt text](img/image-15.png)
github action
![alt text](img/image-14.png)
выполнено
![alt text](img/image-16.png)
в registry есть нужный image
![alt text](img/image-17.png)
deployment использует новую версию приложения 
![alt text](img/image-18.png)