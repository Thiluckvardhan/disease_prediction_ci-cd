pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps { 
                echo "Checkout stage (empty)"
            }
        }

        stage('Build Docker Image') {
            steps { 
                echo "Build stage (empty)"
            }
        }

        stage('Docker Login') {
            steps { 
                echo "Docker login stage (empty)"
            }
        }

        stage('Push to Docker Hub') {
            steps { 
                echo "Push stage (empty)"
            }
        }

        stage('Terraform Apply') {
            steps { 
                echo "Terraform stage (empty)"
            }
        }

        stage('Ansible Deploy') {
            steps { 
                echo "Ansible stage (empty)"
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully."
        }
    }
}
