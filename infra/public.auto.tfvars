registry_name = "a148ru-netology-registry"
vpc_name = "testing-vpc"
default_zone = {
    a="ru-central1-a",
    b="ru-central1-b",
    c="ru-central1-d"
}
default_cidr = {
    a=["10.0.1.0/24"],
    b=["10.0.2.0/24"],
    c=["10.0.3.0/24"]
}
platform = {
    1 = "standard-v1"
    2 = "standard-v2"
    3 = "standard-v3"
}
vm_param = {
    test = ({
      cores = 2,
      memory = 1,
      core_fract = 20
    })
}
user_name = "ubuntu"
k8s_version = "1.32"
node_resource = {
    "cores" = 2
    "core_fraction" = 50
    "memory" = 2
    "disk_size" = 64
}
cluster = {
    region = "ru-central1"
}
allow_ip = [ "87.117.10.45/32" ]
env_file = "../.env"