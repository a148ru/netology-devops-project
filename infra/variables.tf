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