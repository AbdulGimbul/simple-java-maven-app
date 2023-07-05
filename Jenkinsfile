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
		        sh 'docker build -t simple-java-app .'
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
	    agent any
            steps {
                sshagent(['your-ssh-credentials']) {
                    sh 'ssh -o StrictHostKeyChecking=no user@your-ec2-instance-ip "bash -s" < ./jenkins/scripts/deliver.sh'
                }
                sleep 60
            }
        }
    }
}

