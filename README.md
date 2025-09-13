## Итоговый проект по курсу DevOps Netology a148ru

### Подготовка

Для развертываня проекта потребуются программы:
- terraform версии 1.9.X
- yc
- kubectl
- git


### Запуск проекта

> [!NOTE]
> Подготовте файл с авторизованными ключами для сервисного аккаунта с необходимыми правами


`./terraform-deploy.sh -a <authorized_key in json> -c <cloud_id> -f <folder_id>`

