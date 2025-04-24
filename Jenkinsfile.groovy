pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/your-username/kafka-pipeline-demo.git'
            }
        }
        stage('Start Kafka Services') {
            steps {
                sh '''
                /opt/kafka/bin/zookeeper-server-start.sh -daemon /opt/kafka/config/zookeeper.properties
                sleep 5
                /opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties
                sleep 5
                /opt/kafka/bin/kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1 || true
                '''
            }
        }
        stage('Run Producer') {
            steps {
                sh 'python3 producer.py'
            }
        }
        stage('Run Consumer') {
            steps {
                sh 'timeout 10s python3 consumer.py'
            }
        }
    }
}