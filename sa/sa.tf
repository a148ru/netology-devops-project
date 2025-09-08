resource "yandex_iam_service_account" "terraform_sa" {
  name = "terraform-sa"
  description  = "Service account for Terraform operations"
}

resource "yandex_iam_service_account_static_access_key" "terraform_sa_static_key" {
  service_account_id = yandex_iam_service_account.terraform_sa.id
}

resource "yandex_resourcemanager_folder_iam_member" "terraform_sa_member"{
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.terraform_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
 # Сервисному аккаунту назначается роль "k8s.clusters.agent".
 folder_id = var.folder_id
 role      = "k8s.clusters.agent"
 member    = "serviceAccount:${yandex_iam_service_account.terraform_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
 # Сервисному аккаунту назначается роль "vpc.publicAdmin".
 folder_id = var.folder_id
 role      = "vpc.publicAdmin"
 member    = "serviceAccount:${yandex_iam_service_account.terraform_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "registry-admin" {
 # Сервисному аккаунту назначается роль "container-registry.admin".
 folder_id = var.folder_id
 role      = "container-registry.admin"
 member    = "serviceAccount:${yandex_iam_service_account.terraform_sa.id}"
}

resource "null_resource" "export_env" {
  depends_on = [ yandex_iam_service_account_static_access_key.terraform_sa_static_key ]
  provisioner "local-exec" {
    command =  <<EOF
echo "export TF_VAR_sa_id='${yandex_iam_service_account.terraform_sa.id}'
export TF_VAR_static_id_key='${yandex_iam_service_account_static_access_key.terraform_sa_static_key.id}'
export TF_VAR_static_access_key='${yandex_iam_service_account_static_access_key.terraform_sa_static_key.access_key}'
export TF_VAR_static_secret_key='${yandex_iam_service_account_static_access_key.terraform_sa_static_key.secret_key}'" > "${var.env_file}"
EOF
  }
}

# 
resource "null_resource" "sa_key_file" {
  depends_on = [ yandex_iam_service_account.terraform_sa ]
  provisioner "local-exec" {
    command = "yc iam key create --folder-id ${var.folder_id} --service-account-id ${yandex_iam_service_account.terraform_sa.id} --output ${var.sa_file_key}"
  }
}
