pipeline {
    agent any

    environment {
        AWS_REGION   = 'ap-south-1'
        TF_WORKSPACE = 'dev'
    }

    stages {

        stage('Terraform Init') {
            steps {
                // Use AWS credentials stored in Jenkins (ID: aws-access)
                withAWS(credentials: 'aws-access', region: env.AWS_REGION) {
                    bat 'terraform init'
                }
            }
        }

        stage('Select/Create Workspace') {
            steps {
                withAWS(credentials: 'aws-access', region: env.AWS_REGION) {
                    bat "terraform workspace select %TF_WORKSPACE% || terraform workspace new %TF_WORKSPACE%"
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withAWS(credentials: 'aws-access', region: env.AWS_REGION) {
                    bat 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Approve to apply infrastructure changes?'
                withAWS(credentials: 'aws-access', region: env.AWS_REGION) {
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Infrastructure successfully provisioned via Terraform.'
        }
        failure {
            echo '❌ Pipeline failed. Check console output.'
        }
    }
}
