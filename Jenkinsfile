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
                    sshagent(credentials: ['jenkins-to-aws']) {
                                            sh "ssh -o StrictHostKeyChecking=no -i ./jenkins/scripts/abdl_aws_key.pem app@13.229.99.205 ls"
                                        }
                }
            }
        }
    }
}