###cloud vars
/* variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
} */

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "storage_id" {
  type = string
}

variable "static_access_key" {
  type = string
}
variable "static_secret_key" {
  type = string
}
variable "auth_file" {
  type = string
}

variable "vpc_name" {
  type = string
  default = "testing-vpc"
}
variable "default_zone" {
  type        = map(string)
  default     = {
    a="ru-central1-a",
    b="ru-central1-b",
    c="ru-central1-d"
    }
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = map(list(string))
  default     = {
    a=["10.0.1.0/24"],
    b=["10.0.2.0/24"],
    c=["10.0.3.0/24"]
  }
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}
variable "image" {
  type = map(string)
  default = { test="ubuntu-2004-lts" }
}

variable "platform" {
  type = map(string)
  default = {
    1 = "standard-v1"
    2 = "standard-v2"
    3 = "standard-v3"
  }
}


variable vm_param {
  type = map(any)
  default = {
    test = ({
      cores = 2,
      memory = 1,
      core_fract = 20
    })
  }
}
variable "user_name" {
  type = string
  default = "ubuntu"
}
variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMk9vrkXYEC0Sm0DBtMXuSTWSH771egCT/P35D2ll6f a148ru@polaris134"
  description = "ssh-keygen -t ed25519"
}