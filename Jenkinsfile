pipeline {
    triggers {
        pollSCM('*/2 * * * *')
    }
    agent {
        docker {
            image 'maven:3.9.3-eclipse-temurin-11'
            args '-p 3000:3000'
            args '-v /root/.m2:/root/.m2'
            // Add the following line to install openssh-client in the container
            //args 'apt-get update && apt-get install -y openssh-client'
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
        agent {
                docker {
                    image 'ubuntu:latest'
                    args '-p 3000:3000''
                }
                steps {
                    script {
                        withCredentials([sshUserPrivateKey(credentialsId: 'jenkins-to-aws', keyFileVariable: 'SSH_KEY')]) {
                            // Start the SSH connection and execute the command
                            sh "ssh -o StrictHostKeyChecking=no -i \"${SSH_KEY}\" app@ec2-13-229-99-205.ap-southeast-1.compute.amazonaws.com 'ls'"
                        }
                    }
                }
            }
        }
    }
}