pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/docker/getting-started.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t getting-started-app ./getting-started'
            }
        }
        stage('Run Docker Container') {
            steps {
                sh '''
          docker rm -f getting-started-container || true
          docker run -d -p 8080:80 --name getting-started-container getting-started-app
        '''
            }
        }
        stage('Test Deployment') {
            steps {
                sh '''
          echo "Waiting for container to start..."
          sleep 5
          curl -s http://localhost:8080 | grep -i docker || (echo "App not responding" && exit 1)
        '''
            }
        }
    }
}
