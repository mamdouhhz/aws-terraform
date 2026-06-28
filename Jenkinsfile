pipeline {
    agent any

    options {
        timestamps()
        ansiColor('xterm')
    }

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'staging', 'prod'],
            description: 'Select the Terraform workspace/environment'
        )
    }

    environment {
        TF_IN_AUTOMATION = "true"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {

                    sh '''
                        terraform version
                        terraform init

                        terraform workspace select ${ENVIRONMENT} || terraform workspace new ${ENVIRONMENT}
                    '''
                }
            }
        }

        // stage('Terraform Format Check') {
        //     steps {
        //         sh 'terraform fmt -check -recursive'
        //     }
        // }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {

                    sh """
                        terraform plan \
                          -var-file=environments/${params.ENVIRONMENT}/terraform.tfvars \
                          -out=tfplan
                    """

                    sh 'terraform show tfplan'
                }
            }
        }

        stage('Approval') {
            steps {
                input(
                    message: "Apply Terraform changes to '${params.ENVIRONMENT}'?",
                    ok: "Apply"
                )
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {

                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Terraform Output') {
            steps {
                sh 'terraform output'
            }
        }
    }

    post {

        success {
            emailext(
                to: 'mamdouhhazemm@gmail.com',
                subject: "✅ ${env.JOB_NAME} #${env.BUILD_NUMBER} Succeeded",
                body: """
The Terraform deployment completed successfully.

Job: ${env.JOB_NAME}
Build: #${env.BUILD_NUMBER}
Environment: ${params.ENVIRONMENT}

Build URL:
${env.BUILD_URL}
"""
            )
        }

        failure {
            emailext(
                to: 'mamdouhhazemm@gmail.com',
                subject: "❌ ${env.JOB_NAME} #${env.BUILD_NUMBER} Failed",
                body: """
The Terraform deployment failed.

Job: ${env.JOB_NAME}
Build: #${env.BUILD_NUMBER}
Environment: ${params.ENVIRONMENT}

Please review the Jenkins console log.

Build URL:
${env.BUILD_URL}
"""
            )
        }

        always {
            archiveArtifacts artifacts: 'tfplan', fingerprint: true, allowEmptyArchive: true

            cleanWs()
        }
    }
}