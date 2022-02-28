pipeline {
    agent any

    tools { 
        maven 'Maven 3.8.4' 
    }

    stages {
        stage ('Initialize') {
            steps {
                // Verify path variables for mvn
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                ''' 
            }
        }
        
        stage('Build') {
            steps {
                sh "git submodule init"
                sh "git submodule update"
                sh "mvn install -Dmaven.test.skip=true"
            }
        }
        stage('Test') {
            steps {
                echo 'Tests go here'
            }
        }
        stage('Push') {
            
            steps {
                script {
                    // us-west-1.amazonaws.com/user-microservice-js
                    docker.withRegistry("https://086620157175.dkr.ecr.us-west-1.amazonaws.com", "ecr:us-west-1:jenkins.aws.credentials.js") {
                        def image = docker.build('user-microservice-js')
                        image.push('latest')
                    } 
                }  
            }
            
        }
        stage('Cleanup') {
            steps {
                sh "docker image rm user-microservice-js:latest"
                sh "docker image rm 086620157175.dkr.ecr.us-west-1.amazonaws.com/user-microservice-js"
                sh "docker image ls"
            }
        }
    }
}
