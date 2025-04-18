pipeline {
  agent any
  environment {
    // Jenkins credentials ID that holds your DockerHub username/password
    DOCKERHUB_CRED = 'f4bb4469-7e31-4cfc-a752-062d8c99b139'
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/mrunalsangade/Social-Media-Image-Captioning-System.git'
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
        // skip or adjust if you don’t have a linter
        sh 'flake8 . || echo "No lint step configured"'
      }
    }
    stage('Test') {
      steps {
        sh 'pytest --junitxml=reports/results.xml'
      }
      post {
        always { junit 'reports/*.xml' }
      }
    }
    stage('Docker Build & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CRED,
                                         usernameVariable: 'USER',
                                         passwordVariable: 'PASS')]) {
          sh '''
            echo $PASS | docker login -u $USER --password-stdin
            docker build -t $USER/captioner:latest .
            docker push $USER/captioner:latest
          '''
        }
      }
    }
  }
}
