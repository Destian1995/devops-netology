
terraform {
  required_providers {
    yandex = {
      source = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoint  = "storage.yandexcloud.net"
    bucket     = "devops"
    region     = "ru-central1-a"
    key        = "terraform/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }

  required_version = ">= 1.1"
}