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

            }
        }
        stage('Deploy') {
            steps {

            }
        }
    }
}