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
            steps {
                input message: 'Proceed with the next stage?', parameters: [booleanParam(defaultValue: false, description: 'Proceed?', name: 'approval')]
            }
        }
        stage('Deploy') {
            when {
                expression { return env.approval == 'true' }
            }
            steps {
                script {
                    def timeoutDuration = 1
                    def startTime = System.currentTimeMillis()
                    def endTime = startTime + (timeoutDuration * 60 * 1000)

                    while (System.currentTimeMillis() < endTime) {
                        // Deployment steps here
                        sh './jenkins/scripts/deliver.sh'

                        sleep time: 1, unit: 'SECONDS'
                    }
                }
            }
        }
    }
}
