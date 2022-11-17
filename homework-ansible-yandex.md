# Домашнее задание к занятию "3. Использование Yandex Cloud"

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

Ссылка на репозиторий LightHouse: https://github.com/VKCOM/lighthouse

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.
4. Приготовьте свой собственный inventory файл `prod.yml`.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

Ответ:
Инфраструктура будет состоять из 3 хостов, развернутых с помощью terraform, он создаст не только тачки, но и создаст inventory файл для ansible
Список команд для развертывания инфраструктуры ниже
```
terraform init
terraform plan 
(проверяем что все корректно)
data.yandex_compute_image.ubuntu: Reading...
data.yandex_vpc_subnet.subnet: Reading...
data.yandex_compute_image.ubuntu: Read complete after 2s [id=fd89dg08jjghmn88ut7p]
data.yandex_vpc_subnet.subnet: Read complete after 2s [id=e9be93p4ja7220cc8b86]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.inventory will be created
  + resource "local_file" "inventory" {
      + content              = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "./hosts.yaml"
      + id                   = (known after apply)
    }

  # yandex_compute_instance.node["clickhouse"] will be created
  + resource "yandex_compute_instance" "node" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLEVXK8R1z3t28A+GrHqYy7xakXmaCNgkMYO0ygrWRzLVaKPHhk8Y7EHnu1yb4gVidqzmiPQMA0Jqik6MfxjjOTcyRF9ypXBiTEUH5K/oTF8d7bFJxKGfwl+zxqkb5nleOPaRqxWNaqoS2Yy3hPojYJrzjgwzc1qA0XtEvbcivP81BB5d/CbLeJOEn5qdLZVpj+KQLoAcAIPnTyjiPyQk6UCJuHk8yPidQLtUR5kTmJCa6nfq85vpahJVchs89q8lpYjhgzSriRu+0Vlu95e107sPgWr8+lGKP9a7Xpls5yyAMRd4YDKkOwlmDHOYfhvuqlfuHIDMv0OsMr+ZinJol vagrant@localhost.localdomain
            EOT
          + "type"     = "clickhouse"
        }
      + name                      = "clickhouse-01"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd89dg08jjghmn88ut7p"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
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
          + subnet_id          = "e9be93p4ja7220cc8b86"
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.node["lighthouse"] will be created
  + resource "yandex_compute_instance" "node" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLEVXK8R1z3t28A+GrHqYy7xakXmaCNgkMYO0ygrWRzLVaKPHhk8Y7EHnu1yb4gVidqzmiPQMA0Jqik6MfxjjOTcyRF9ypXBiTEUH5K/oTF8d7bFJxKGfwl+zxqkb5nleOPaRqxWNaqoS2Yy3hPojYJrzjgwzc1qA0XtEvbcivP81BB5d/CbLeJOEn5qdLZVpj+KQLoAcAIPnTyjiPyQk6UCJuHk8yPidQLtUR5kTmJCa6nfq85vpahJVchs89q8lpYjhgzSriRu+0Vlu95e107sPgWr8+lGKP9a7Xpls5yyAMRd4YDKkOwlmDHOYfhvuqlfuHIDMv0OsMr+ZinJol vagrant@localhost.localdomain
            EOT
          + "type"     = "lighthouse"
        }
      + name                      = "lighthouse-01"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd89dg08jjghmn88ut7p"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
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
          + subnet_id          = "e9be93p4ja7220cc8b86"
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.node["vector"] will be created
  + resource "yandex_compute_instance" "node" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLEVXK8R1z3t28A+GrHqYy7xakXmaCNgkMYO0ygrWRzLVaKPHhk8Y7EHnu1yb4gVidqzmiPQMA0Jqik6MfxjjOTcyRF9ypXBiTEUH5K/oTF8d7bFJxKGfwl+zxqkb5nleOPaRqxWNaqoS2Yy3hPojYJrzjgwzc1qA0XtEvbcivP81BB5d/CbLeJOEn5qdLZVpj+KQLoAcAIPnTyjiPyQk6UCJuHk8yPidQLtUR5kTmJCa6nfq85vpahJVchs89q8lpYjhgzSriRu+0Vlu95e107sPgWr8+lGKP9a7Xpls5yyAMRd4YDKkOwlmDHOYfhvuqlfuHIDMv0OsMr+ZinJol vagrant@localhost.localdomain
            EOT
          + "type"     = "vector"
        }
      + name                      = "vector-01"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd89dg08jjghmn88ut7p"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
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
          + subnet_id          = "e9be93p4ja7220cc8b86"
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

Plan: 4 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
[vagrant@localhost ansible-yandex]$

```

Видим что проблем нет.
Будем иметь:
```
Сервер clickhouse-01 для сбора логов.
Сервер vector-01, генерирующий и обрабатывающий логи.
Сервер lighthouse-01 - веб-интерфейс для clickhouse-01
```
Приступаем к развертыванию
```
terraform apply --auto-approve
[vagrant@localhost ansible-yandex]$ terraform apply --auto-approve
data.yandex_vpc_subnet.subnet: Reading...
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 3s [id=fd89dg08jjghmn88ut7p]
data.yandex_vpc_subnet.subnet: Read complete after 3s [id=e9be93p4ja7220cc8b86]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.inventory will be created
  + resource "local_file" "inventory" {
      + content              = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "./hosts.yaml"
      + id                   = (known after apply)
    }

  # yandex_compute_instance.node["clickhouse"] will be created
  + resource "yandex_compute_instance" "node" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLEVXK8R1z3t28A+GrHqYy7xakXmaCNgkMYO0ygrWRzLVaKPHhk8Y7EHnu1yb4gVidqzmiPQMA0Jqik6MfxjjOTcyRF9ypXBiTEUH5K/oTF8d7bFJxKGfwl+zxqkb5nleOPaRqxWNaqoS2Yy3hPojYJrzjgwzc1qA0XtEvbcivP81BB5d/CbLeJOEn5qdLZVpj+KQLoAcAIPnTyjiPyQk6UCJuHk8yPidQLtUR5kTmJCa6nfq85vpahJVchs89q8lpYjhgzSriRu+0Vlu95e107sPgWr8+lGKP9a7Xpls5yyAMRd4YDKkOwlmDHOYfhvuqlfuHIDMv0OsMr+ZinJol vagrant@localhost.localdomain
            EOT
          + "type"     = "clickhouse"
        }
      + name                      = "clickhouse-01"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd89dg08jjghmn88ut7p"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
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
          + subnet_id          = "e9be93p4ja7220cc8b86"
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.node["lighthouse"] will be created
  + resource "yandex_compute_instance" "node" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLEVXK8R1z3t28A+GrHqYy7xakXmaCNgkMYO0ygrWRzLVaKPHhk8Y7EHnu1yb4gVidqzmiPQMA0Jqik6MfxjjOTcyRF9ypXBiTEUH5K/oTF8d7bFJxKGfwl+zxqkb5nleOPaRqxWNaqoS2Yy3hPojYJrzjgwzc1qA0XtEvbcivP81BB5d/CbLeJOEn5qdLZVpj+KQLoAcAIPnTyjiPyQk6UCJuHk8yPidQLtUR5kTmJCa6nfq85vpahJVchs89q8lpYjhgzSriRu+0Vlu95e107sPgWr8+lGKP9a7Xpls5yyAMRd4YDKkOwlmDHOYfhvuqlfuHIDMv0OsMr+ZinJol vagrant@localhost.localdomain
            EOT
          + "type"     = "lighthouse"
        }
      + name                      = "lighthouse-01"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd89dg08jjghmn88ut7p"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
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
          + subnet_id          = "e9be93p4ja7220cc8b86"
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.node["vector"] will be created
  + resource "yandex_compute_instance" "node" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLEVXK8R1z3t28A+GrHqYy7xakXmaCNgkMYO0ygrWRzLVaKPHhk8Y7EHnu1yb4gVidqzmiPQMA0Jqik6MfxjjOTcyRF9ypXBiTEUH5K/oTF8d7bFJxKGfwl+zxqkb5nleOPaRqxWNaqoS2Yy3hPojYJrzjgwzc1qA0XtEvbcivP81BB5d/CbLeJOEn5qdLZVpj+KQLoAcAIPnTyjiPyQk6UCJuHk8yPidQLtUR5kTmJCa6nfq85vpahJVchs89q8lpYjhgzSriRu+0Vlu95e107sPgWr8+lGKP9a7Xpls5yyAMRd4YDKkOwlmDHOYfhvuqlfuHIDMv0OsMr+ZinJol vagrant@localhost.localdomain
            EOT
          + "type"     = "vector"
        }
      + name                      = "vector-01"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd89dg08jjghmn88ut7p"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
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
          + subnet_id          = "e9be93p4ja7220cc8b86"
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

Plan: 4 to add, 0 to change, 0 to destroy.
yandex_compute_instance.node["vector"]: Creating...
yandex_compute_instance.node["clickhouse"]: Creating...
yandex_compute_instance.node["lighthouse"]: Creating...
yandex_compute_instance.node["vector"]: Still creating... [10s elapsed]
yandex_compute_instance.node["clickhouse"]: Still creating... [10s elapsed]
yandex_compute_instance.node["lighthouse"]: Still creating... [10s elapsed]
yandex_compute_instance.node["vector"]: Still creating... [20s elapsed]
yandex_compute_instance.node["clickhouse"]: Still creating... [20s elapsed]
yandex_compute_instance.node["lighthouse"]: Still creating... [20s elapsed]
yandex_compute_instance.node["lighthouse"]: Still creating... [30s elapsed]
yandex_compute_instance.node["clickhouse"]: Still creating... [30s elapsed]
yandex_compute_instance.node["vector"]: Still creating... [30s elapsed]
yandex_compute_instance.node["vector"]: Still creating... [40s elapsed]
yandex_compute_instance.node["clickhouse"]: Still creating... [41s elapsed]
yandex_compute_instance.node["lighthouse"]: Still creating... [41s elapsed]
yandex_compute_instance.node["clickhouse"]: Creation complete after 43s [id=fhm3qp0sjlpir93iklfu]
yandex_compute_instance.node["lighthouse"]: Creation complete after 43s [id=fhmdiuddb4p5hajm9pld]
yandex_compute_instance.node["vector"]: Still creating... [50s elapsed]
yandex_compute_instance.node["vector"]: Creation complete after 57s [id=fhmk6l785m5a7r1tsqtc]
local_file.inventory: Creating...
local_file.inventory: Creation complete after 0s [id=65819afa925849dade50276b59152546aec50dbd]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
[vagrant@localhost ansible-yandex]$
```
Развернули, проверяем:








## Playbook

Playbook производит развертывание необходимых приложений на указанные сервера. 
Для простоты деплоя все хосты сделаны доступными через интернет. 

- ### Clickhouse

  - установка `clickhouse`
  - настройка удаленных подключений к приложению
  - создание базы данных и таблицы в ней


- ### Vector

  - установка `vector`
  - изменение конфига приложения для отправки логов на сервер `clickhouse-01`

- ### Lighthouse

  - установка `lighthouse`
  - настройка `nginx`

## Variables

Через group_vars можно задать следующие параметры:
- `clickhouse_version`, `vector_installer_url`, `lighthouse_distrib` - версии устанавливаемых приложений;
- `clickhouse_database_name` - имя базы данных для хранения логов;
- `clickhouse_create_table` - структуру таблицы для хранения логов;
- `vector_config` - содержимое конфигурационного файла для приложения `vector`;
- блок конфигурации `nginx` для работы с `lighthouse`;

## Tags

- `clickhouse` производит полную конфигурацию сервера `clickhouse-01`;
- `clickhouse_db` производит конфигурацию базы данных и таблицы;
- `vector` производит полную конфигурацию сервера `vector-01`;
- `vector_config` производит изменение в конфиге приложения `vector`;
- `lighthouse` производит установку `lighthouse`.
- `drop_clickhouse_database_logs` удаляет базу данных (по умолчанию не выполняется);
