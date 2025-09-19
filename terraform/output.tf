output "jenkins_server_ip" {
  description = "External IP address of the Jenkins server"
  value       = google_compute_instance.jenkins_server.network_interface[0].access_config[0].nat_ip
}

output "sonar_server_ip" {
  description = "External IP address of the SonarQube server"
  value       = google_compute_instance.sonar-server.network_interface[0].access_config[0].nat_ip
}

output "nexus_server_ip" {
  description = "External IP address of the Nexus server"
  value       = google_compute_instance.nexus-server.network_interface[0].access_config[0].nat_ip
}

# GKE cluster info
output "gke_cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "gke_cluster_location" {
  description = "The location (zone) of the GKE cluster"
  value       = google_container_cluster.primary.location
}

output "gke_cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = google_container_cluster.primary.endpoint
}

output "gke_node_pool_name" {
  description = "The name of the GKE node pool"
  value       = google_container_node_pool.primary_nodes.name
}

output "gke_node_count" {
  description = "The number of nodes in the primary node pool"
  value       = google_container_node_pool.primary_nodes.node_count
}
