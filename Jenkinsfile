pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                dir("user-microservice"){
                    sh "export MAVEN_HOME=/var/jenkins_home/maven/apache-maven-3.6.3"
                    sh "export PATH=$PATH:$MAVEN_HOME/bin"
                    sh "mvn --version"
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
                script{
                    image = docker.build user-microservice-js
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    docker.withRegistry("086620157175.dkr.ecr.us-west-1.amazonaws.com/user-microservice-js", "ecr:us-east-1:wc-ecr-access") {
                        image.push('latest')
                    } 
                }  
            }
        }
    }
}
