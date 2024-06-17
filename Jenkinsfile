pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'feature/jenkins', url: 'https://github.com/daedov/nginx-aws-ec2'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage( 'Terraform fmt') {
            steps {
                sh 'terraform fmt'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -input=false -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -input=false -auto-approve'
            }
        }
    }

}