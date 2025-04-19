pipeline {
  agent any

  environment {
    // replace with your Jenkins DockerHub creds ID
    DOCKERHUB_CRED = 'f4bb4469-7e31-4cfc-a752-062d8c99b139'
  }

  options {
    // so we can do our own shallow checkout
    skipDefaultCheckout()
  }

  stages {
    stage('Checkout') {
      steps {
        // shallow clone just the latest commit
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
        // ensure pip is the latest
        bat 'python -m pip install --upgrade pip'
        // install everything you listed in requirements.txt
        bat 'pip install -r requirements.txt'
      }
    }

    stage('Lint') {
      steps {
        // if you install flake8, this will lint; otherwise it just echoes
        bat 'flake8 . || echo Skipping lint — no flake8 installed'
      }
    }

    stage('Build') {
      steps {
        // Python apps usually don’t have a build step
        bat 'echo No build step required'
      }
    }

    stage('Test') {
      steps {
        // create reports folder if it doesn't exist
        bat 'if not exist reports mkdir reports'
        // run pytest and output JUnit‑style XML
        bat 'pytest --junitxml=reports/results.xml'
      }
      post {
        // publish test results
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
          // login, build, tag & push
          bat 'echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin'
          bat 'docker build -t %DOCKER_USER%/captioner:latest .'
          bat 'docker push %DOCKER_USER%/captioner:latest'
        }
      }
    }
  }
}
