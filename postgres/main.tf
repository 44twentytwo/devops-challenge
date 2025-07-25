terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
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
    host_path      = abspath("${path.module}/data")
    container_path = "/var/lib/postgresql/data"
  }

  restart = "unless-stopped"
}
