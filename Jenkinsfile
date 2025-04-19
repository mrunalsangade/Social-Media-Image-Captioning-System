pipeline {
  agent any

  environment {
    // your DockerHub creds ID in Jenkins
    DOCKERHUB_CRED = 'f4bb4469-7e31-4cfc-a752-062d8c99b139'
  }

  options {
    // skip the default SCM checkout so we can do a shallow clone
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
        bat 'pip install --upgrade pip'
        bat 'pip install -r requirements.txt'
      }
    }

    stage('Build') {
      steps {
        // Python app doesn’t have a build step—just echo for clarity
        bat 'echo "No build step required for Python project"'
      }
    }

    stage('Test') {
      steps {
        // ensure reports folder exists
        bat 'if not exist reports mkdir reports'
        // run pytest and output JUnit‑style XML
        bat 'pytest --junitxml=reports/results.xml'
      }
      post {
        // publish the test results in Jenkins
        always { junit 'reports/*.xml' }
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
