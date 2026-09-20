terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "open_webui" {
  name = "ghcr.io/open-webui/open-webui:v0.11.0"
}

resource "docker_container" "open_webui" {
  name         = "open-webui"
  image        = docker_image.open_webui.image_id
  network_mode = "host"
  restart      = "unless-stopped"

  env = [
    "OLLAMA_BASE_URL=http://127.0.0.1:11434"
  ]

  volumes {
    volume_name    = "open-webui"
    container_path = "/app/backend/data"
  }
}
