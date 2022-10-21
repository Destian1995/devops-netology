terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.70.0"
    }
  }
    backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "devops"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = ""
    secret_key = ""
	
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
