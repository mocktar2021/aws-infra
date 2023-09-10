pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-user')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-user')
        TF_BACKEND_BUCKET     = 'mocktarltd-terraform-state-bucket'
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from GitHub
                checkout scm
            }
        }
        stage('Deploy Infra') {
            steps {
                script {
                    // Check for changes in .tf files
                    def changes = bat(script: 'git diff --name-only origin/master...HEAD | findstr \\.tf$', returnStatus: true)
                    
                    if (changes == 0) {
                        echo 'No .tf files changed. Skipping deployment.'
                    } else {
                        // Your deployment steps here
                        echo 'Changes detected in .tf files. Deploying...'
                        
                        // Deploy resources based on Terraform configurations
                        bat 'terraform init -backend-config="bucket=%TF_BACKEND_BUCKET%"'
                        bat 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
}
