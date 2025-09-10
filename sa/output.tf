
output "service_account_id" {
  value = yandex_iam_service_account.terraform_sa.id
}


output "service_account_key" {
  value = yandex_iam_service_account_key.sa-key
}