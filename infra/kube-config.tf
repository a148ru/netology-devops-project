# 
resource "null_resource" "kube_config" {
  depends_on = [ yandex_kubernetes_cluster.cluster ]
  provisioner "local-exec" {
    command = "yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.cluster.id} --external --force"
  }
}
