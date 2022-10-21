terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }


  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform"
    region     = "ru-central1-a"
    key        = "terraform/terraform.tfstate"
    access_key = ""
    secret_key = ""

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     =  var.YC_TOKEN
  cloud_id    = "b1gfodjsfjm1ue7u0ld7"
  folder_id   = "b1ggthdvv3nparichh2u"
  zone        = "ru-central1-a"
}