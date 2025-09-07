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
output "registry_id" {
  value = yandex_container_registry.registry.id
}
resource "null_resource" "export_registry_id" {
  depends_on = [ yandex_container_registry.registry ]
  provisioner "local-exec" {
    command =  "echo 'export DOCKER_REGISTRY=${yandex_container_registry.registry.id}' > .env"
  }
}