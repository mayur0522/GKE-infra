resource "google_container_cluster" "primary" {
  name     = "gke-cluster"
  location = var.zone
 
  remove_default_node_pool = true
  initial_node_count       = 1
 
  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {}
  deletion_protection = false
}
 
resource "google_container_node_pool" "primary_nodes" {
  name       = "gke-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = 2
 
  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
 
    metadata = {
      disable-legacy-endpoints = "true"
    }
 
    labels = {
      env = "dev"
    }
 
    tags = ["gke-node"]
  }
}