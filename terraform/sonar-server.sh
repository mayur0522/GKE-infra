#!/bin/bash
apt update -y
apt install -y docker.io 

docker run -d -p 9000:9000 --name sonar-server sonarqube:latest