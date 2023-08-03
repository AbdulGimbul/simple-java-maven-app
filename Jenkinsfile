pipeline {
    triggers {
        pollSCM('*/2 * * * *')
    }
    agent {
        docker {
            image 'abdl00/maven-custom-image'
            args '-p 3000:3000'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Manual Approval') {
            input {
                message "Lanjutkan ke deploy?"
                ok "Yes, of course"
            }
            steps {
                echo "Let's go"
            }
        }
        stage('Deploy') {
            steps {
                // Copy JAR file to EC2 instance using SCP
                script {
                    def remoteDir = 'app' // Replace with your remote directory path
                    def jarPath = 'target/*.jar' // Replace with your JAR path
                    def jarFileName = '*.jar' // Replace with your JAR path
                    def deployPath = 'jenkins/scripts/deploy.sh'
                    def deployScript = 'deploy.sh'
                    def ec2PublicIp = '13.229.99.205' // Replace with your EC2 instance public IP

                    // Restart the application on the EC2 instance (if a previous instance is running)
                    sshagent(credentials: ['jenkins-to-aws']) {
                        // Copy the JAR file to the remote directory
                        sh "scp -o StrictHostKeyChecking=no -i ./jenkins/scripts/abdl_aws_key.pem ${jarPath} ${deployPath} app@${ec2PublicIp}:${remoteDir}/"
                        sh "ssh -o StrictHostKeyChecking=no -i ./jenkins/scripts/abdl_aws_key.pem app@${ec2PublicIp} 'bash ${remoteDir}/${deployScript}'"
                    }
                }
            }
        }
    }
}