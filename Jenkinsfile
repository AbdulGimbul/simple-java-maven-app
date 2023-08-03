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
                sh 'chmod 400 ./jenkins/scripts/abdl_aws_key.pem'
                script {
                    def remote = [:]
                    remote.name = 'app'
                    remote.host = 'ec2-13-229-99-205.ap-southeast-1.compute.amazonaws.com'
                    remote.user = 'app'
                    remote.identityFile = 'jenkins/scripts/abdl_aws_key.pem'
                    remote.allowAnyHosts = true

                    sshCommand remote: remote, command: "ls"
                }
            }
        }
    }
}