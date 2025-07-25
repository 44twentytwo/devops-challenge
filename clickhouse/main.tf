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

  ports {
    internal = 9000
    external = var.native_port
  }

  ports {
    internal = 8123
    external = var.http_port
  }

  volumes {
    host_path      = abspath("${path.module}/data")
    container_path = "/var/lib/clickhouse"
  }

  env = [
    "CLICKHOUSE_DB=default",
    "CLICKHOUSE_USER=default",
    "CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1"
  ]

  restart = "unless-stopped"
}
