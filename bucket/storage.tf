resource "random_id" "bucket" {
  byte_length = 8
}
resource "yandex_storage_bucket" "terraform_state" {
  bucket = "terraform-state-${random_id.bucket.hex}"
  folder_id = var.folder_id
  
  default_storage_class = "standard"

  anonymous_access_flags {
    read = false
    list = false
    config_read = false
  }
}
resource "yandex_storage_bucket_iam_binding" "sa-editor" {
  bucket = yandex_storage_bucket.terraform_state.bucket
  role = "storage.editor"
  members = [ "serviceAccount:${var.sa_id}" ]
}

resource "null_resource" "export_env" {
  depends_on = [ yandex_storage_bucket.terraform_state ]
  provisioner "local-exec" {
    command =  <<EOF
echo "export TF_VAR_storage_id='${yandex_storage_bucket.terraform_state.id}'" >> ${var.env_file}
EOF
  }
}