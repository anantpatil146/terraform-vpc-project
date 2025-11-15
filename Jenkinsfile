pipeline {
    agent any
    environment {
        TF_WORKSPACE = "dev"
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/anantpatil146/terraform-vpc-project.git'
            }
        }
        stage('Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Select Workspace') {
            steps {
                sh "terraform workspace select ${TF_WORKSPACE} || terraform workspace new ${TF_WORKSPACE}"
            }
        }
        stage('Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
        stage('Apply') {
            steps {
                input 'Apply infrastructure changes?'
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
