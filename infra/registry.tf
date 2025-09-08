resource "yandex_container_registry" "registry" {
  name = var.registry_name
  folder_id = var.folder_id
  labels = {
    project = "netology"
  }
}
resource "yandex_container_registry_ip_permission" "allow-ip" {
  registry_id = yandex_container_registry.registry.id
  push = var.allow_ip
  pull = var.allow_ip
}
output "registry_endpoint" {
  value = "${yandex_container_registry.registry.id}"
}