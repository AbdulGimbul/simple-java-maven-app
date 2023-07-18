pipeline {
    triggers {
        pollSCM('*/2 * * * *')
    }
    agent {
        docker {
            image 'maven:3.8.6-openjdk-11'
            args '-p 3000:3000'
            args '-v /root/.m2:/root/.m2'
            args '--privileged'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Dockerize') {
            steps {
                echo 'Starting to build docker image'

                script {
                    def customImage = docker.build("abdl00/simple-java-app")
                }
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
        stage('Push') {
            steps {
                echo "push"
            }
        }
        stage('Deploy') {
            steps {
                sh 'chmod 400 ./jenkins/scripts/java-simple-app.pem'
                sh '''
                    ssh -o StrictHostKeyChecking=no \
                        -i "./jenkins/scripts/java-simple-app.pem" \
                        ec2-user@ec2-52-74-163-106.ap-southeast-1.compute.amazonaws.com \
                        "bash -s" < ./jenkins/scripts/deploy.sh
                '''
                sleep 60
            }
        }
    }
}