/* 
data "yandex_compute_image" "ubuntu" {
  family = var.image.test
}

resource "yandex_compute_instance" "platform" {
  for_each = var.default_zone
  name        = "vm-${each.key}"
  platform_id = var.platform.3
  resources {
    cores         = var.vm_param.test.cores
    memory        = var.vm_param.test.memory
    core_fraction = var.vm_param.test.core_fract
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop[each.key].id
    nat       = true
  }
  zone = each.value
  metadata = {
    serial-port-enable = 1
    ssh-keys           = "${var.user_name}:${var.vms_ssh_root_key}"
  }

} */