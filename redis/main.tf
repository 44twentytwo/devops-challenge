terraform {
  backend "local" {
    path = "/opt/terraform-volumes/redis/data/terraform.tfstate"
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

  command = ["redis-server", "--appendonly", "yes"]

  ports {
    internal = 6379
    external = var.port
  }

  volumes {
    host_path      = "/opt/terraform-volumes/redis/data"
    container_path = "/data"
  }

  restart = "unless-stopped"
}
