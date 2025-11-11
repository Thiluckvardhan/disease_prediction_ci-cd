pipeline {
    agent any

    environment {
        DOCKERHUB_REPO = "thiluck/disease:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                bat '''
                where docker
                docker version
                docker build -t local-disease:build .
                '''
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat 'docker login -u %DOCKER_USER% -p %DOCKER_PASS%'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                bat '''
                docker tag local-disease:build %DOCKERHUB_REPO%
                docker push %DOCKERHUB_REPO%
                docker manifest inspect %DOCKERHUB_REPO%
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Docker image successfully pushed to ${env.DOCKERHUB_REPO}"
        }
    }
}
