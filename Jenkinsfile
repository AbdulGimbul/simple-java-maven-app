pipeline {
    triggers {
        pollSCM('*/2 * * * *')
    }
    agent {
        docker {
            image 'maven:3.9.0-openjdk-11-slim'
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
                sh '''
                    ssh -o StrictHostKeyChecking=no \
                        -i "./jenkins/scripts/java-simple-app.pem" \
                        ec2-user@ec2-52-74-163-106.ap-southeast-1.compute.amazonaws.com \
                        "bash -s" < ./jenkins/scripts/deliver.sh
                '''
                sleep 60
            }
        }
    }
}

