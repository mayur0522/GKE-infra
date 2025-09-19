resource "google_compute_instance" "sonar-server" {
  name         = "sonar-server"
  machine_type = "e2-standard-2" 
  zone         = "${var.region}-c" 
  


  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20230918" # Example Ubuntu image, update as needed
      size  = 20
    }
  }

  network_interface {
    network    = "default" # Use your network name if different
    subnetwork = "default" # Use your subnetwork name if different

    access_config {
      # Ephemeral public IP
    }
  }

  metadata_startup_script = file("./sonar-server.sh")

  tags = ["sonar-server"]

  service_account {
    email  = "default"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}