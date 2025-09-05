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

variable "sa_id" {
  type = string
}

variable "k8s_version" {
  type = string
  default = "1.32"
}

variable "node_resource" {
  type = map(number)
  default = {
    "cores" = 2
    "core_fraction" = 50
    "memory" = 2
    "disk_size" = 64
  }
}

variable "cluster" {
  type = map(string)
  default = {
    region = "ru-central1"
  }
}