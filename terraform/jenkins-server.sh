#!/bin/bash
# Startup script for Jenkins server on GCP (Ubuntu 22.04)
# Installs Jenkins, Docker, Maven, gcloud SDK, and kubectl

################################################################################################
# 1. System Update & Java (required for Jenkins)
################################################################################################
sudo apt update -y
sudo apt install -y openjdk-17-jre unzip curl wget gnupg ca-certificates apt-transport-https software-properties-common

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
# 5. Google Cloud SDK & kubectl
################################################################################################
# Install gcloud SDK
curl -sSL https://sdk.cloud.google.com | bash

# Ensure kubectl is installed
sudo apt install -y kubectl

################################################################################################
# 6. Enable and Restart Jenkins Service
################################################################################################
sudo systemctl enable jenkins
sudo systemctl restart jenkins

echo "✅ Jenkins, Docker, Maven, gcloud SDK, and kubectl installed successfully!"
