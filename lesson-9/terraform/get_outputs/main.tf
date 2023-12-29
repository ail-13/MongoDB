terraform {
  # Версия terraform
  required_version = "~> 1.6.4"
  required_providers {
    google = {
      # Версия провайдера
      version = "5.2.0"
    }
  }
  # создаем отдельный state в облаке
  backend "gcs" {
    bucket      = "tfstate-backet-lesson-9"
    prefix      = "stage/state.output"
    credentials = "./../credentials.json"
  }
}

# Считываем state с инфраструктурой из GCS
data "terraform_remote_state" "infra" {
  backend = "gcs"
  config = {
    bucket      = "tfstate-backet-lesson-9"
    prefix      = "stage/state.infra"
    credentials = "./../credentials.json"
  }
}
