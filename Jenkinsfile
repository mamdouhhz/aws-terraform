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
                ech "Hello World from trigger ${params.ENVIRONMENT}"
            }
        }

        stage('Hello Jenkins') {
            steps {
                echo "Hello Jenkins from ${params.ENVIRONMENT}"
            
        }
    }

post {
    success {
        echo 'Pipeline completed successfully!'
    }

    failure {
        emailext(
            subject: "❌ Jenkins Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: """
The Jenkins build has failed.

Job: ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}
Environment: ${params.ENVIRONMENT}
Status: ${currentBuild.currentResult}

Build URL:
${env.BUILD_URL}
""",
            to: "mamdouhhazemm@gmail.com"
        )

        echo 'Failure email sent.'
    }
}
}
