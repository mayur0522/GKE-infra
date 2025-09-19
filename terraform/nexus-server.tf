resource "google_compute_instance" "nexus-server" {
  name         = "nexus-server"
  machine_type = "e2-standard-2"
  zone         = "${var.region}-c"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20230918"
      size  = 30
    }
  }

  network_interface {
    network    = "default"
    subnetwork = "default"

    access_config {}
  }

  metadata_startup_script = file("./nexus-server.sh")

  tags = ["nexus-server"]

  service_account {
    email  = "default"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}