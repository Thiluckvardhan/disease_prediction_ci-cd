pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        // correctly run checkout inside a node/workspace
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        // intentionally empty
        echo 'Build stage (no-op)'
      }
    }

    stage('Docker Login') {
      steps {
        echo 'Docker login stage (no-op)'
      }
    }

    stage('Push to Docker Hub') {
      steps {
        echo 'Push stage (no-op)'
      }
    }

    stage('Terraform Apply') {
      steps {
        echo 'Terraform stage (no-op)'
      }
    }

    stage('Ansible Deploy') {
      steps {
        echo 'Ansible stage (no-op)'
      }
    }
  }

  post {
    success {
      echo "Pipeline finished successfully."
    }
    failure {
      echo "Pipeline failed."
    }
  }
}
