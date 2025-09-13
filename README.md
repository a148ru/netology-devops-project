## Итоговый проект по курсу DevOps Netology a148ru

## Как развернуть проект
#### Подготовка

Для автоматического развертывания проекта необходимы программы:
- [terraform версии 1.9.X](https://developer.hashicorp.com/terraform/install)
- [yc cli](https://yandex.cloud/ru/docs/cli/operations/install-cli)
- [kubectl](https://kubernetes.io/ru/docs/tasks/tools/install-kubectl/)
- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

у вас уже должно быть зарегистрировано облако в Yandex Cloud и создан каталог для проекта. 

#### Запуск проекта
 
Для развертывания проекта склонируйте проект с помощью git

$ `git clone https://github.com/a148ru/netology-devops-project.git`

Выполните

```
$ cd netology-dev-project
$ ./terraform-deploy.sh -a <authorized_key in json> -c <cloud_id> -f <folder_id>`
```



## Описание выполнения проекта


