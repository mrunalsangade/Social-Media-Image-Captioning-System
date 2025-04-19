pipeline {
  agent any
  stages {
    // (Jenkins will still do the default "Checkout SCM" first)
    stage('Install Dependencies') {
      steps {
        // on Windows, use bat; adjust if you’re on Linux or macOS
        bat 'python -m pip install --upgrade pip'
        bat 'pip install -r requirements.txt'
      }
    }

    stage('Hello') {
      steps {
        echo '🚀 Jenkins is working!'
      }
    }
  }
}
