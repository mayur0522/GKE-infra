variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "asia-south1"
}

variable "zone" {
  description = "The GCP zone where the GKE cluster will be created"
  type        = string
  default     = "asia-south1-b"
}

variable "gke_cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "gke-cluster"
}

variable "gke_node_pool_name" {
  description = "The name of the GKE node pool"
  type        = string
  default     = "gke-node-pool"
}

variable "gke_machine_type" {
  description = "Machine type for the GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "gke_node_count" {
  description = "Number of nodes in the node pool"
  type        = number
  default     = 2
}


