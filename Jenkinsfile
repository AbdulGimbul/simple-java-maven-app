pipeline {
    triggers {
        pollSCM('*/2 * * * *')
    }
    agent {
        docker {
            image 'maven:3.8.6-openjdk-11'
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
        stage('Dockerize') {
        agent {
                docker {
                    image 'docker:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'docker build -t abdl00/simple-java-app .'
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
                sh 'docker push abdl00/simple-java-app'
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