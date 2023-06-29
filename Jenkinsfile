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
    environment {
        approval = ''
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
            steps {
                script {
                    def userInput = input(
                        message: 'Proceed with the next stage?',
                        parameters: []
                    )
                    env.approval = userInput ? 'true' : 'false'
                    echo "Approval value: ${env.approval}"
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    if (env.approval == 'true') {
                        def timeoutDuration = 5
                        def startTime = System.currentTimeMillis()
                        def endTime = startTime + (timeoutDuration * 60 * 1000)

                        while (System.currentTimeMillis() < endTime) {
                            // Deployment steps here
                            sh './jenkins/scripts/deliver.sh'

                            sleep time: 1, unit: 'SECONDS'
                        }
                    } else {
                        echo 'Skipping deployment stage.'
                    }
                }
            }
        }
    }
}
