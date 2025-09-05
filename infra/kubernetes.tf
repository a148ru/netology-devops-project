resource "yandex_kubernetes_cluster" "cluster" {
 network_id = yandex_vpc_network.develop.id


master {
    regional {
      region = var.cluster.region
    
      dynamic "location" {
        for_each = [for s in values(yandex_vpc_subnet.develop) : {
          zone = s.zone
          subnet_id = s.id
        }]
        content {
          zone = location.value.zone
          subnet_id = location.value.subnet_id
        }
      }
    }
  
  version = var.k8s_version
  public_ip = true
  
  scale_policy {
    auto_scale {
      min_resource_preset_id = "s-c2-m8"
    }
  }
  security_group_ids = [yandex_vpc_security_group.cluster.id]
 }
 service_account_id      = var.sa_id
 node_service_account_id = var.sa_id
}
