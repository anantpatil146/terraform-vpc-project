pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        // ❌ Removed TF_WORKSPACE here to avoid conflict
    }

    stages {

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-access'   // <- your Jenkins AWS credential ID
                ]]) {
                    bat 'terraform init'
                }
            }
        }

        stage('Select/Create Workspace') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-access'
                ]]) {
                    // ✅ Now we explicitly work with "dev" workspace via CLI
                    bat 'terraform workspace select dev || terraform workspace new dev'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-access'
                ]]) {
                    bat 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Approve to apply infrastructure changes?'
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-access'
                ]]) {
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
