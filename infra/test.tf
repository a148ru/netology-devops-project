resource "yandex_compute_image" "ubuntu_2004" {
  source_family = "ubuntu-2004-lts"
}
resource "yandex_compute_disk" "boot-disk-vm3" {
  name     = "boot-disk-3"
  type     = "network-hdd"
  zone     = "ru-central1-d"
  size     = "20"
  image_id = yandex_compute_image.ubuntu_2004.id
}