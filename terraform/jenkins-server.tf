# Fetch latest Ubuntu 22.04 LTS image from the ubuntu-os-cloud project
data "google_compute_image" "ubuntu_2204" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "jenkins_server" {
  name         = "jenkins-server"
  machine_type = "e2-medium"
  zone         = "${var.region}-b"
  
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_2204.self_link
      size  = 20
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = file("./jenkins-server.sh")
  tags = ["jenkins"]

  labels = {
    name = "jenkins-server"
  }

  service_account {
    email  = "default"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}