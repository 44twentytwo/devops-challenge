terraform {
  backend "local" {
    path = "/opt/terraform-volumes/postgres/tfstate/terraform.tfstate"
  }

  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "this" {
  name = var.image
}

resource "docker_container" "this" {
  name  = var.container_name
  image = docker_image.this.name

  env = [
    "POSTGRES_DB=${var.db}",
    "POSTGRES_USER=${var.user}",
    "POSTGRES_PASSWORD=${var.password}"
  ]

  ports {
    internal = 5432
    external = var.port
  }

  volumes {
    host_path      = "/opt/terraform-volumes/postgres/data"
    container_path = "/var/lib/postgresql/data"
  }

  restart = "unless-stopped"
}
