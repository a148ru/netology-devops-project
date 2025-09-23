resource "yandex_kubernetes_node_group" "ng-1" {
  name        = var.node_group.name
  description = "Node group"
  cluster_id  = yandex_kubernetes_cluster.cluster.id
  version     = var.k8s_version
  instance_template {
    name = "${var.node_group.instance_name_prefix}-{instance.short_id}-{instance_group.id}"
    platform_id = var.platform.3
    resources {
      cores         = var.node_resource.cores
      core_fraction = var.node_resource.core_fraction
      memory        = var.node_resource.memory
    }
    boot_disk {
      size = var.node_resource.disk_size
      type = var.node_group.disk_type
    }
    network_acceleration_type = var.node_group.network_acceleration_type
    network_interface {
      security_group_ids = [yandex_vpc_security_group.cluster.id]
      subnet_ids         = [yandex_vpc_subnet.develop["a"].id, yandex_vpc_subnet.develop["b"].id, yandex_vpc_subnet.develop["c"].id]
      nat                = var.node_nat
    }
    scheduling_policy {
      preemptible = true
    }

    metadata = {
      "ssh-keys" = "${var.user}:${file("${var.ssh_key_file}")}"
    }
  }
  scale_policy {
    fixed_scale {
      size = var.scale_policy.size
    }
  }
  deploy_policy {
    max_expansion   = var.deploy_policy.max_expansion
    max_unavailable = var.deploy_policy.max_unavailable
  }
  maintenance_policy {
    auto_upgrade = var.maintenance_policy.auto_upgrade
    auto_repair  = var.maintenance_policy.auto_repair
    maintenance_window {
      start_time = var.maintenance_window.start_time
      duration   = var.maintenance_window.duration
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
}
