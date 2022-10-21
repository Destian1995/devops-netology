terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.70.0"
    }
  }
    backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "Devops"
    region     = "ru-central1"
    key        = "devops-netology/terraform-basic/terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
