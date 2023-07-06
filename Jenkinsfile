pipeline {
    triggers {
        pollSCM('*/2 * * * *')
    }
    agent any

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
        stage('Build Docker Image') {
            agent {
                docker {
                    image 'maven:3.9.0'
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                sh 'docker build -t your-image-name .'
            }
        }
        stage('Manual Approval') {
            steps {
                input {
                    message "Proceed with the deployment?"
                    ok "Yes, proceed"
                }
                echo "Let's go"
            }
        }
        stage('Deploy to EC2') {
            agent any
            steps {
                sshagent(['your-ssh-credentials']) {
                    sh 'scp -i path/to/keypair.pem your-image-name user@your-ec2-instance-ip:/home/user/your-image-name'
                    sh 'ssh -o StrictHostKeyChecking=no -i path/to/keypair.pem user@your-ec2-instance-ip "docker load -i /home/user/your-image-name"'
                    sh 'ssh -o StrictHostKeyChecking=no -i path/to/keypair.pem user@your-ec2-instance-ip "docker run -d --name your-container-name your-image-name"'
                }
            }
        }
    }
}