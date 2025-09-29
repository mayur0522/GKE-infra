#!/bin/bash
# Startup script for Jenkins server on GCP (Ubuntu 22.04)
# Installs Jenkins, Docker, Maven, gcloud SDK, kubectl, GKE auth plugin, and Trivy

################################################################################################
# 1. System Update & Java (required for Jenkins)
################################################################################################
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y openjdk-17-jre unzip curl wget gnupg ca-certificates apt-transport-https software-properties-common lsb-release

################################################################################################
# 2. Jenkins Installation
################################################################################################
# Add Jenkins GPG key
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins repository
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list and install Jenkins
sudo apt update -y
sudo apt install -y jenkins

# Allow Jenkins user to use sudo without password
echo "jenkins ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

################################################################################################
# 3. Docker Installation
################################################################################################
# Create keyrings directory
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list and install Docker
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add Jenkins user to Docker group and set permissions
sudo usermod -aG docker jenkins
sudo chmod 666 /var/run/docker.sock

################################################################################################
# 4. Maven Installation
################################################################################################
sudo apt install -y maven

################################################################################################
# 5. Google Cloud SDK, kubectl, and GKE Auth Plugin
################################################################################################
# Add Google Cloud SDK repo and key
sudo apt-get install -y apt-transport-https ca-certificates gnupg

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.gpg > /dev/null

# Install gcloud SDK, kubectl, and GKE auth plugin
sudo apt update -y
sudo apt install -y google-cloud-sdk kubectl google-cloud-sdk-gke-gcloud-auth-plugin

# Set env var for GKE auth plugin (important for Jenkins builds)
echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" | sudo tee -a /etc/profile
echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" | sudo tee -a /etc/environment
echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" | sudo tee -a /home/jenkins/.bashrc

################################################################################################
# 6. Trivy Installation (Vulnerability Scanner)
################################################################################################
sudo apt-get install -y wget apt-transport-https gnupg lsb-release

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | \
  sudo tee /etc/apt/sources.list.d/trivy.list

sudo apt-get update -y
sudo apt-get install -y trivy

################################################################################################
# 7. Enable and Restart Jenkins Service
################################################################################################
sudo systemctl enable jenkins
sudo systemctl restart jenkins

echo "✅ Jenkins, Docker, Maven, gcloud SDK, kubectl, GKE auth plugin, and Trivy installed successfully!"
