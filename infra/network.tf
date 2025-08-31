resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  for_each = var.default_zone
  name           = "${var.vpc_name}-${each.key}"
  zone           = each.value
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr[each.key]
}
