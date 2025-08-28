pipeline {
    agent any
    
    environment {
        AWS_REGION = 'ap-southeast-2'  // Sydney region
        TF_WORKSPACE = 'production'
        GIT_REPO_URL = 'https://github.com/SubbuKadali/jenkins-cloudformation-ec2.git'
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                url: 'https://github.com/SubbuKadali/jenkins-cloudformation-ec2.git'
            }
        }
        
        stage('Terraform Init') {
            steps {
                dir('.') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-terraform-creds',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                        sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=$AWS_REGION
                        terraform init -input=false
                        '''
                    }
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                dir('.') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-terraform-creds',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                        sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=$AWS_REGION
                        terraform plan -out=tfplan -input=false
                        '''
                    }
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir('.') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-terraform-creds',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                        sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=$AWS_REGION
                        terraform apply -input=false -auto-approve tfplan
                        '''
                    }
                }
            }
            post {
                success {
                    script {
                        def PUBLIC_IP = sh(script: 'terraform output -raw instance_public_ip', returnStdout: true).trim()
                        def INSTANCE_ID = sh(script: 'terraform output -raw instance_id', returnStdout: true).trim()
                        
                        echo "✅ EC2 Instance created successfully!"
                        echo "🌏 Region: ap-southeast-2 (Sydney)"
                        echo "🆔 Instance ID: ${INSTANCE_ID}"
                        echo "📍 Public IP: ${PUBLIC_IP}"
                        echo "🔗 GitHub Repo: https://github.com/SubbuKadali/jenkins-cloudformation-ec2.git"
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs() // Clean workspace after build
            echo "🎉 Pipeline execution completed!"
        }
        failure {
            echo "❌ Pipeline failed! Check the logs for errors."
        }
    }
}
