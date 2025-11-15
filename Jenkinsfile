pipeline {
    agent any

    environment {
        AWS_REGION   = 'ap-south-1'
        TF_WORKSPACE = 'dev'
    }

    stages {

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-access'   // 🔹 ID of your AWS creds in Jenkins
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
                    bat "terraform workspace select %TF_WORKSPACE% || terraform workspace new %TF_WORKSPACE%"
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
