pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                dir("user-microservice"){
                    sh "mvn clean package"
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Testing! For real!'
            }
        }
        stage('Dockerize') {
            steps {
                withAWS(credentials: 'aws-credentials', region: 'us-west-1') {
                    sh "docker build -t user-microservice-js ."
                    sh "docker tag user-microservice-js:latest 086620157175.dkr.ecr.us-west-1.amazonaws.com/user-microservice-js:latest"
                    sh "docker push 086620157175.dkr.ecr.us-west-1.amazonaws.com/user-microservice-js:latest"
                }
            }
        }
        stage('Push') {
            steps {
                echo 'Already pushed!'
            }
        }
    }
}