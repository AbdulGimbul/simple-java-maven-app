pipeline {
    triggers {
        pollSCM('*/2 * * * *')
    }
    agent {
        docker {
            image 'maven:3.9.3-eclipse-temurin-11'
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
                script {
                    // Make sure to provide the correct path to the private key file
                    def keyFilePath = './jenkins/scripts/abdl_aws_key.pem'

                    // Start the SSH agent and add the private key to it
                    sshagent(credentials: ['jenkins-to-aws']) {
                        sh 'chmod 400 ' + keyFilePath

                        // SSH connection and command execution
                        sh "ssh -o StrictHostKeyChecking=no -i ${keyFilePath} app@ec2-13-229-99-205.ap-southeast-1.compute.amazonaws.com 'ls'"
                    }
                }
            }
        }
    }
}