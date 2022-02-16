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
        stage('Deploy') {
            steps {
                echo 'It is deploying, for sure'
            }
        }
    }
}