pipeline {
  agent any
// hi
  environment {
    DOCKERHUB_REPO = "docker.io/thiluck/disease:latest"
  }

  options { ansiColor('xterm') }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t disease:build .'
      }
    }

    stage('Login & Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub_creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh '''
            echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
            docker tag local-disease:build ${DOCKERHUB_REPO}
            docker push ${DOCKERHUB_REPO}
          '''
        }
      }
    }
  }

  post {
    success {
      echo "✅ Docker image successfully pushed to ${DOCKERHUB_REPO}"
    }
  }
}
