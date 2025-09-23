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

/* variable "static_access_key" {
  type = string
}

variable "static_secret_key" {
  type = string
} */

variable "auth_file" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "default_zone" {
  type        = map(string)
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = map(list(string))
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "platform" {
  type = map(string)
}

variable vm_param {
  type = map(any)
}

variable "user_name" {
  type = string
}

variable "sa_id" {
  type = string
}

variable "k8s_version" {
  type = string
}

variable "node_resource" {
  type = map(number)
}

variable "cluster" {
  type = map(string)
}

variable "registry_name" {
  type = string
}

variable "allow_ip" {
  type = list(string)
}
variable "env_file" {
  type = string
}
variable "ssh_key_file" {
  type = string
  default = "~/.ssh/id_ed25519.pub"
}
variable "user" {
  type = string
  default = "tester"
}
variable "master_resource" {
  type = string
  default = "s-c2-m8"
}
variable "kms_key" {
  type = map(string)
  default = {
    "name" = "kms-key"
    "algorithm" = "AES_128"
    "rotation" = "8760h" # 1 год
  }
}
variable "sg_name" {
  type = string
  default = "sg"
}
variable "registry_labels" {
  type = map(string)
}
variable "node_group" {
  type = map(string)
  default = {
    name = "ng"
    instance_name_prefix = "instance"
    disk_type = "network-ssd"
    network_acceleration_type = "standard"
  }
}
variable "node_nat" {
  type = bool
  default = true
}
variable "maintenance_window" {
  type = map(string)
  default = {
    start_time = "22:00"
    duration   = "10h"
  }
}
variable "scale_policy" {
  type = map(number)
  default = {
    size = 3
  }
}
variable "deploy_policy" {
  type = map(number)
  default = {
    max_expansion   = 5
    max_unavailable = 2
  }
}
variable "maintenance_policy" {
  type = map(bool)
  default = {
    auto_upgrade = true
    auto_repair  = true
  }
}
variable "master_public_ip" {
  type = bool
  default = true
}