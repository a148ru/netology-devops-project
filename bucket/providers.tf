
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.9.8"
}


provider "yandex" {
  service_account_key_file = var.sa_file_key
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}