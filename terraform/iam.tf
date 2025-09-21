variable "project_id" {
  default = "gke-springboot-472605"
}

# Jenkins / Terraform Service Account
resource "google_service_account" "jenkins_sa" {
  account_id   = "jenkins-sa"
  display_name = "Jenkins CI/CD Service Account"
  project      = var.project_id
}

# IAM Roles required
locals {
  roles = [
    "roles/compute.admin",
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/artifactregistry.admin",
    "roles/iam.serviceAccountUser",
    "roles/logging.viewer",
    "roles/monitoring.viewer"
  ]
}

# Attach roles to Jenkins SA
resource "google_project_iam_member" "jenkins_roles" {
  for_each = toset(local.roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.jenkins_sa.email}"
}

# Output service account email
output "jenkins_sa_email" {
  value = google_service_account.jenkins_sa.email
}
