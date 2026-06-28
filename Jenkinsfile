pipeline {
    agent any

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'stg', 'prod'],
            description: 'Select the environment'
        )
    }

    stages {
        stage('Hello World') {
            steps {
                echo "Hello World from trigger ${params.ENVIRONMENT}"
            }
        }
        

        stage('Hello Jenkins') {
            steps {
                echo "Hello Jenkins from ${params.ENVIRONMENT}"
                error("Intentional failure")
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            emailext(
                subject: "❌ ${env.JOB_NAME} #${env.BUILD_NUMBER} Failed",
                body: """
Job: ${env.JOB_NAME}
Build: #${env.BUILD_NUMBER}
Environment: ${params.ENVIRONMENT}

Build URL:
${env.BUILD_URL}
""",
                to: "mamdouhhazemm@gmail.com"
            )
        }
    }
}
