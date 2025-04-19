pipeline {
  agent any

  environment {
    DOCKERHUB_CRED = 'f4bb4469-7e31-4cfc-a752-062d8c99b139'
  }

  options {
    skipDefaultCheckout()
  }

  stages {
    stage('Checkout') {
      steps {
        // shallow‐clone only latest commit
        checkout([
          $class: 'GitSCM',
          branches: [[ name: '*/main' ]],
          userRemoteConfigs: [[
            url: 'https://github.com/mrunalsangade/Social-Media-Image-Captioning-System.git'
          ]],
          extensions: [
            [$class: 'CloneOption', shallow: true, depth: 1, noTags: true]
          ]
        ])
      }
    }

    stage('Install Dependencies') {
      steps {
        sh 'pip install --upgrade pip'
        sh 'pip install -r requirements.txt'
      }
    }

    stage('Lint') {
      steps {
        // remove this line or install flake8 if you don’t lint
        sh 'flake8 . || echo "No lint configured"'
      }
    }

    stage('Build') {
      steps {
        // no build step for Python; included per spec
        sh 'echo "No build step required for Python project"'
      }
    }

    stage('Test') {
      steps {
        sh 'mkdir -p reports'
        sh 'pytest --junitxml=reports/results.xml'
      }
      post {
        always {
          junit 'reports/*.xml'
        }
      }
    }

    stage('Docker Build & Push') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: env.DOCKERHUB_CRED,
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh '''
            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
            docker build -t $DOCKER_USER/captioner:latest .
            docker push $DOCKER_USER/captioner:latest
          '''
        }
      }
    }
  }
}
