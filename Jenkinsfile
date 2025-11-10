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

    stage('Login & Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub_creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          bat '''
          @echo off
          echo %DH_PASS% | docker login -u %DH_USER% --password-stdin
          docker tag local-disease:build %DOCKERHUB_REPO%
          docker push %DOCKERHUB_REPO%
          docker manifest inspect %DOCKERHUB_REPO%
          '''
        }
      }
    }
  }

  post {
    success { echo "✅ Pushed to ${env.DOCKERHUB_REPO}" }
  }
}
