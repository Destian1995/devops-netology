# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
2. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 


## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
2. Создайте два воркспейса `stage` и `prod`.
3. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
4. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
5. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
6. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
7. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
```
vagrant@vagrant:~/devops-netology/terraform-basic$ terraform workspace list
  default
* prod
  stage
```

* Вывод команды `terraform plan` для воркспейса `prod`.  

```
vagrant@vagrant:~/devops-netology/terraform-basic$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.instance-1[0] will be created
  + resource "yandex_compute_instance" "instance-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "vm-prod-1.netology.cloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzhU5jV7L2hC9QXX4LpTl52Wo6oJI6CAFQx890DCAp1WBhOWgj0Ajz51InF6vqdtSIEPxOlb+8U6BuoiyMWr8xI7l4IVlIsyazlaiA/KobSNZXzBI3kHHMaqJJcuwaA7ltrMw57GZHDvx1uwYPT9ua3Tgt20+jfKpQqxkNzpm1fOU3QPQJIrV4RxajonJWqSoTrOXohuJmBl0OB5KJumSOWTcsmkie3G92jwaj9f/nSlbzvzGQmBriTvJJ/RfArci4PK2978W9w7yxIdjNns7sWx0qcP2YnUhgDFdCBQM6IxFn26GK6tMKdB/I28M+f6op3rh07PmNainSdcK3vMGUY5xNJvWZDVuU3hfvgRpXNVvwgDmqCl8+DYdRGfngraqzZvq9ZQcV1M5WbhgmejFkvHmR3wawMbHTdfrD1mla5H+gk6DiT3br05OXAJ+Bso8u3IjeySFCbdFK7oAy2vo9n7VjT17LBq8Uc3C5ZzkKOPDQzOGmIpGkcNwIrdMuHBU= vagrant@vagrant
            EOT
        }
      + name                      = "vm-prod-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd81hgrcv6lsnkremf32"
              + name        = "root-vm-prod-1"
              + size        = 50
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.instance-1[1] will be created
  + resource "yandex_compute_instance" "instance-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "vm-prod-2.netology.cloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzhU5jV7L2hC9QXX4LpTl52Wo6oJI6CAFQx890DCAp1WBhOWgj0Ajz51InF6vqdtSIEPxOlb+8U6BuoiyMWr8xI7l4IVlIsyazlaiA/KobSNZXzBI3kHHMaqJJcuwaA7ltrMw57GZHDvx1uwYPT9ua3Tgt20+jfKpQqxkNzpm1fOU3QPQJIrV4RxajonJWqSoTrOXohuJmBl0OB5KJumSOWTcsmkie3G92jwaj9f/nSlbzvzGQmBriTvJJ/RfArci4PK2978W9w7yxIdjNns7sWx0qcP2YnUhgDFdCBQM6IxFn26GK6tMKdB/I28M+f6op3rh07PmNainSdcK3vMGUY5xNJvWZDVuU3hfvgRpXNVvwgDmqCl8+DYdRGfngraqzZvq9ZQcV1M5WbhgmejFkvHmR3wawMbHTdfrD1mla5H+gk6DiT3br05OXAJ+Bso8u3IjeySFCbdFK7oAy2vo9n7VjT17LBq8Uc3C5ZzkKOPDQzOGmIpGkcNwIrdMuHBU= vagrant@vagrant
            EOT
        }
      + name                      = "vm-prod-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd81hgrcv6lsnkremf32"
              + name        = "root-vm-prod-2"
              + size        = 50
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.instance-2["3"] will be created
  + resource "yandex_compute_instance" "instance-2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "vm-prod-3.netology.cloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzhU5jV7L2hC9QXX4LpTl52Wo6oJI6CAFQx890DCAp1WBhOWgj0Ajz51InF6vqdtSIEPxOlb+8U6BuoiyMWr8xI7l4IVlIsyazlaiA/KobSNZXzBI3kHHMaqJJcuwaA7ltrMw57GZHDvx1uwYPT9ua3Tgt20+jfKpQqxkNzpm1fOU3QPQJIrV4RxajonJWqSoTrOXohuJmBl0OB5KJumSOWTcsmkie3G92jwaj9f/nSlbzvzGQmBriTvJJ/RfArci4PK2978W9w7yxIdjNns7sWx0qcP2YnUhgDFdCBQM6IxFn26GK6tMKdB/I28M+f6op3rh07PmNainSdcK3vMGUY5xNJvWZDVuU3hfvgRpXNVvwgDmqCl8+DYdRGfngraqzZvq9ZQcV1M5WbhgmejFkvHmR3wawMbHTdfrD1mla5H+gk6DiT3br05OXAJ+Bso8u3IjeySFCbdFK7oAy2vo9n7VjT17LBq8Uc3C5ZzkKOPDQzOGmIpGkcNwIrdMuHBU= vagrant@vagrant
            EOT
        }
      + name                      = "vm-prod-3"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd81hgrcv6lsnkremf32"
              + name        = "root-vm-prod-3"
              + size        = 50
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.instance-2["4"] will be created
  + resource "yandex_compute_instance" "instance-2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "vm-prod-4.netology.cloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzhU5jV7L2hC9QXX4LpTl52Wo6oJI6CAFQx890DCAp1WBhOWgj0Ajz51InF6vqdtSIEPxOlb+8U6BuoiyMWr8xI7l4IVlIsyazlaiA/KobSNZXzBI3kHHMaqJJcuwaA7ltrMw57GZHDvx1uwYPT9ua3Tgt20+jfKpQqxkNzpm1fOU3QPQJIrV4RxajonJWqSoTrOXohuJmBl0OB5KJumSOWTcsmkie3G92jwaj9f/nSlbzvzGQmBriTvJJ/RfArci4PK2978W9w7yxIdjNns7sWx0qcP2YnUhgDFdCBQM6IxFn26GK6tMKdB/I28M+f6op3rh07PmNainSdcK3vMGUY5xNJvWZDVuU3hfvgRpXNVvwgDmqCl8+DYdRGfngraqzZvq9ZQcV1M5WbhgmejFkvHmR3wawMbHTdfrD1mla5H+gk6DiT3br05OXAJ+Bso8u3IjeySFCbdFK7oAy2vo9n7VjT17LBq8Uc3C5ZzkKOPDQzOGmIpGkcNwIrdMuHBU= vagrant@vagrant
            EOT
        }
      + name                      = "vm-prod-4"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd81hgrcv6lsnkremf32"
              + name        = "root-vm-prod-4"
              + size        = 50
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network1"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 6 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you
run "terraform apply" now.
vagrant@vagrant:~/devops-netology/terraform-basic$
```
---