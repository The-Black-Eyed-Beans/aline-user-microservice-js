pipeline {
    agent any

    tools { 
        maven 'Maven 3.8.4' 
    }
    
    environment {
        AWS_ID = credentials("aws.id")
        AWS_DEFAULT_REGION = credentials("deployment.region")
        MICROSERVICE_NAME = "user-microservice-js"
        DEPLOYMENT_NAME = "user-deployment"
    }

    stages {
        stage ('Initialize') {
            steps {

                // Verify path variables for mvn
                sh '''
                    echo "Preparing to build, test and deploy ${MICROSERVICE_NAME}"
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                ''' 
                sh "aws s3 cp s3://js-env-vars/backend.env ."
                sh "ls -a"
            }
        }
        
        stage('Build') {
            steps {
                sh "git submodule init"
                sh "git submodule update"
                sh "mvn install -Dmaven.test.skip=true"
            }
        }
        stage('Sonar Scan'){
            steps{
                withSonarQubeEnv('SonarQube-Server'){
                    sh 'mvn verify sonar:sonar -Dmaven.test.skip=true'
                }
            }
        }
        
        stage('Quality Gate'){
            steps{
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage('Push') {
            steps {
                script {
                    docker.withRegistry("https://${AWS_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com", "ecr:${AWS_DEFAULT_REGION}:jenkins.aws.credentials.js") {
                        def image = docker.build("${MICROSERVICE_NAME}")
                        image.push('latest')
                    } 
                }  
            }
        }

        stage('Deploy'){
            steps {  
                withAWS(credentials: 'js-aws-credentials', region: 'us-west-1') { 
                    //sh "aws ecr get-login-password | docker login --username AWS --password-stdin 086620157175.dkr.ecr.us-west-1.amazonaws.com"
                    sh "aws eks update-kubeconfig --profile jsherer --name=EKSCluster-js --region=us-west-1"
                    //sh "aws eks update-kubeconfig --name=EKSCluster-js --region=us-west-1"
                }
                sh "kubectl apply -f ${DEPLOYMENT_NAME}.yaml"
            }
        }

        stage ('Update Deployment'){
            steps {
                script{
                    try{
                        withAWS(credentials: 'js-aws-credentials', region: 'us-west-1') { 
                            sh "kubectl scale deploy ${DEPLOYMENT_NAME} --replicas=0"
                            sh "kubectl scale deploy ${DEPLOYMENT_NAME} --replicas=1"
                            sh "echo 'Restarted ${DEPLOYMENT_NAME}.'"
                        }
                    }catch(exc){
                        sh "echo 'No existing ${DEPLOYMENT_NAME} was detected, new ${DEPLOYMENT_NAME} was created.'"
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh "docker image rm ${MICROSERVICE_NAME}:latest"
                sh 'docker image rm $AWS_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$MICROSERVICE_NAME'
                sh "docker image prune -f"
                sh "mvn clean"
            }
        }
    }
}
