resource "yandex_kubernetes_node_group" "ng-1" {
  name        = "ng"
  description = "Node group"
  cluster_id  = yandex_kubernetes_cluster.cluster.id
  version     = var.k8s_version
  instance_template {
    name = "instance-{instance.short_id}-{instance_group.id}"
    platform_id = var.platform.3
    resources {
      cores         = var.node_resource.cores
      core_fraction = var.node_resource.core_fraction
      memory        = var.node_resource.memory
    }
    boot_disk {
      size = var.node_resource.disk_size
      type = "network-ssd"
    }
    network_acceleration_type = "standard"
    network_interface {
      security_group_ids = [yandex_vpc_security_group.cluster.id]
      subnet_ids         = [yandex_vpc_subnet.develop["a"].id, yandex_vpc_subnet.develop["b"].id, yandex_vpc_subnet.develop["c"].id]
      nat                = false
    }
    scheduling_policy {
      preemptible = true
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }
  deploy_policy {
    max_expansion   = 5
    max_unavailable = 2
  }
  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
    maintenance_window {
      start_time = "22:00"
      duration   = "10h"
    }
  }
  allocation_policy {
    location {
      zone = var.default_zone.a
    }
    location {
      zone = var.default_zone.b
    }
    location {
      zone = var.default_zone.c
    }
  }
  # node_taints = ["taint1=taint-value1:NoSchedule"]
  # labels = {
  #   "my-label" = "value1"
  # }
  # allowed_unsafe_sysctls = ["kernel.msg*", "net.core.somaxconn"]
}
