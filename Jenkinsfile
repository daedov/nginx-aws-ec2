pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        PRIVATE_KEY_AWS = credentials('PRIVATE_KEY_AWS')
    }


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

        stage('Terraform Apply') {
            withCredentials([file(credentialsId: ' PRIVATE_KEY_AWS ')]) {
            sh 'terraform apply -auto-approve'
            }
        }
    }
    
    post {
        always {
            archiveArtifacts artifacts: '**/*.tfstate', allowEmptyArchive: true
        }
    }

}