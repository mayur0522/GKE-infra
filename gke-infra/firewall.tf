# sonar-server 
resource "google_compute_firewall" "sonar-server-fw" {
  name    = "sonar-server-fw"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "9000"]
  }

  target_tags = ["sonar-server"]

  source_ranges = ["0.0.0.0/0"]
}

# jenkins-server
resource "google_compute_firewall" "jenkins-server-fw" {
  name    = "jenkins-server-fw"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  target_tags = ["jenkins"]

  source_ranges = ["0.0.0.0/0"]
}
# nexus-server
resource "google_compute_firewall" "nexus-server-fw" {
  name    = "nexus-server-fw"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8081"]
  }

  target_tags = ["nexus-server"]

  source_ranges = ["0.0.0.0/0"]
}