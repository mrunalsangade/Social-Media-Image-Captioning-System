pipeline {
  agent any

  environment {
    // Replace with your Jenkins DockerHub credentials ID
    DOCKERHUB_CRED = 'f4bb4469-7e31-4cfc-a752-062d8c99b139'
  }

  stages {
    /* Default “Checkout SCM” is handled automatically */

    stage('Install Dependencies') {
      steps {
        // make sure pip is up to date
        bat 'python -m pip install --upgrade pip'
        // install from your requirements.txt
        bat 'python -m pip install -r requirements.txt'
      }
    }

    stage('Build') {
      steps {
        // no compile/build step needed for this Python app
        bat 'echo No build step required'
      }
    }

    stage('Test') {
      steps {
        // create a folder for test reports
        bat 'if not exist reports mkdir reports'
        // run pytest and output JUnit‑style XML
        bat 'python -m pytest --junitxml=reports/results.xml'
      }
      post {
        // publish test results in Jenkins
        always {
          junit 'reports/*.xml'
        }
      }
    }

    stage('Docker Build & Push') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: "${DOCKERHUB_CRED}",
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          // log in, build, tag & push your image
          bat 'echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin'
          bat 'docker build -t %DOCKER_USER%/captioner:latest .'
          bat 'docker push %DOCKER_USER%/captioner:latest'
        }
      }
    }
  }
}
