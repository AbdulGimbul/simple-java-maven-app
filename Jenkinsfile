pipeline {
    triggers {
        pollSCM('*/2 * * * *')
    }
    agent {
        docker {
            image 'maven:3.9.0'
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
        stage('Install SSH Client') {
            steps {
                // Install openssh-client package on the Jenkins agent node
                sh 'apt-get update -y'
                sh 'apt-get install -y openssh-client'
            }
        }
        stage('Deploy') {
            steps {
                sh 'chmod 400 ./jenkins/scripts/abdl_aws_key.pem'
                sh '''
                    ssh -o StrictHostKeyChecking=no \
                        -i "./jenkins/scripts/abdl_aws_key.pem" \
                        ec2-user@ec2-52-74-163-106.ap-southeast-1.compute.amazonaws.com \
                        "bash -s" < ./jenkins/scripts/deploy.sh
                '''
                sleep 60
            }
        }
    }
}