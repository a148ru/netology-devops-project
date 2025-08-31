resource "yandex_kubernetes_cluster" "cluster" {
 network_id = yandex_vpc_network.develop.id
 master {
   master_location {
     zone      = yandex_vpc_subnet.develop["a"].zone
     subnet_id = yandex_vpc_subnet.develop["a"].id
   }
 }
 service_account_id      = var.sa_id
 node_service_account_id = var.sa_id
   /* depends_on = [
     yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
     yandex_resourcemanager_folder_iam_member.vpc-public-admin,
     yandex_resourcemanager_folder_iam_member.images-puller
   ] */
}


