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
                dir('ec2') {
                    withCredentials([file(credentialsId: 'PRIVATE_KEY_AWS', variable: 'KEY_FILE')]) {
                        sh 'cp $KEY_FILE ./key-aws.pem'
                    }
                }    
            }
        }

        stage('Terraform Init') {
            steps {
                dir('ec2') {
                    sh 'terraform init'
                }    
            }
        }

        stage('Terraform fmt') {
            steps {
                dir('ec2') {
                    sh 'terraform fmt'
                }
            }
        }

        stage('Terraform plan') {
            steps {
                dir('ec2') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('ec2') {
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
        
        stage('Terraform Destroy') {
            steps {
                dir('ec2') {
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'terraform destroy -auto-approve'
                    }
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