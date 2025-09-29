resource "google_compute_instance" "nexus_server" {
  name         = "nexus-server"
  machine_type = "e2-standard-2"
  zone         = "${var.region}-c"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_2204.self_link
      size  = 30
    }
  }

  network_interface {
    network    = "default"
    subnetwork = "default"
    access_config {}
  }

  metadata_startup_script = file("./scripts/nexus-server.sh")

  tags = ["nexus-server"]

  service_account {
    email  = "default"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
