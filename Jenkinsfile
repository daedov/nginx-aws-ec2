pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'develop', url: 'https://github.com/daedov/nginx-aws-ec2'
            }
        }

        stage('Prepare SSH Key') {
            steps {
                withCredentials([file(credentialsId: 'PRIVATE_KEY_AWS', variable: 'KEY_FILE')]) {
                    sh '''
                        cp $KEY_FILE ./key-aws.pem
                        chmod 600 ./key-aws.pem
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform fmt') {
            steps {
                sh 'terraform fmt'
            }
        }

        stage('Terraform plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        terraform apply -auto-approve
                    '''
                }
            }
        }
        
        stage('Terraform Destroy') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        terraform destroy -auto-approve
                    '''
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/*.tfstate', allowEmptyArchive: true
            sh 'rm -f ./key-aws.pem'
        }
    }
}
