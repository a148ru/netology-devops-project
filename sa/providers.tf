terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.9.8"
}

provider "yandex" {
  #token     = var.token
  service_account_key_file = var.auth_file
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}