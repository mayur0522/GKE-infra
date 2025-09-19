resource "google_artifact_registry_repository" "docker_repo" {
  provider = google
  location = var.region
  repository_id = "springboot-artifacts"
  description   = "Docker repository for Spring Boot microservices"
  format        = "DOCKER"
  mode          = "STANDARD_REPOSITORY"
}
