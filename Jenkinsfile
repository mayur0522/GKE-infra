pipeline {
    agent any

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        PROJECT_ID   = 'gke-springboot-472605'
        REGION       = 'asia-south1'
        ZONE         = 'asia-south1-b'
        CLUSTER      = 'gke-cluster'
        IMAGE_NAME   = 'springboot-app'
        REPO         = "asia-south1-docker.pkg.dev/${gke-springboot-472605}/springboot-artifacts/${IMAGE_NAME}"
    }

    tools {
        maven 'maven3'
        jdk 'jdk-17'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Yogeshjathar/CategoryProduct.git'
            }
        }

        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }

        stage('Unit Tests') {
            steps {
                sh "mvn test -DskipTests=true"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh """
                        ${env.SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=EKART \
                        -Dsonar.projectName=EKART \
                        -Dsonar.java.binaries=target/classes
                    """
                }
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'DC'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('Build') {
            steps {
                sh "mvn package -DskipTests=true"
            }
        }

        stage('Deploy to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'global-maven', jdk: 'jdk-17', maven: 'maven3', traceability: true) {
                    sh "mvn deploy -DskipTests=true"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${REPO}:latest -f docker/Dockerfile ."
                }
            }
        }

        stage('Authenticate with GCP') {
            steps {
                withCredentials([file(credentialsId: 'gcp-service-account-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                    sh "gcloud config set project ${PROJECT_ID}"
                    sh "gcloud auth configure-docker asia-south1-docker.pkg.dev"
                }
            }
        }

        stage('Push Docker Image to Artifact Registry') {
            steps {
                sh "docker push ${REPO}:latest"
            }
        }

        stage('Get GKE Credentials') {
            steps {
                sh "gcloud container clusters get-credentials ${CLUSTER} --zone ${ZONE} --project ${PROJECT_ID}"
            }
        }

        stage('Deploy to GKE') {
            steps {
                sh """
                    kubectl set image deployment/springboot-app springboot-app=${REPO}:latest
                    kubectl rollout status deployment/springboot-app
                """
            }
        }
    }

    post {
        success {
            echo 'Spring Boot project deployed successfully to GKE!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
