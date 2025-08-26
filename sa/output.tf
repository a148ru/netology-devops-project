/* output "public_key" {
  value = yandex_iam_service_account_key.terraform_sa_key.public_key
}
output "private_key" {
  value = yandex_iam_service_account_key.terraform_sa_key.private_key
  sensitive = true
}
output "sa_id" {
  value = "${yandex_iam_service_account.terraform_sa.id}"
}
output "static_id_key" {
  value = yandex_iam_service_account_static_access_key.terraform_sa_static_key.id
}
output "static_access_key" {
  value = yandex_iam_service_account_static_access_key.terraform_sa_static_key.access_key
}
output "static_secret_key" {
  value = yandex_iam_service_account_static_access_key.terraform_sa_static_key.secret_key
  sensitive = true
} */