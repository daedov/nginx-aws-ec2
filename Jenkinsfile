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
                        sh 'cp $KEY_FILE $WORKSPACE/key-aws.pem'
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
                    sh 'terraform plan -out=plan.out'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    def applyDecision = input(
                        id: 'applyDecision', message: 'Do you want to apply Terraform changes?', parameters: [
                            choice(choices: ['Yes', 'No'], description: 'Choose whether to proceed with Terraform apply', name: 'continue')
                        ]
                    )

                    if (applyDecision == 'Yes') {
                        dir('ec2') {
                            withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                                sh 'terraform apply -auto-approve plan.out'
                            }
                        }
                    } else {
                        echo 'Terraform apply was cancelled by the user.'
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                script {
                    def destroyDecision = input(
                        id: 'destroyDecision', message: 'Do you want to destroy Terraform resources?', parameters: [
                            choice(choices: ['Yes', 'No'], description: 'Choose whether to proceed with Terraform destroy', name: 'continue')
                        ]
                    )

                    if (destroyDecision == 'Yes') {
                        dir('ec2') {
                            withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                                sh 'terraform destroy -auto-approve'
                            }
                        }
                    } else {
                        echo 'Terraform destroy was cancelled by the user.'
                    }
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/*.tfstate', allowEmptyArchive: true
            sh 'rm -f $WORKSPACE/key-aws.pem'
        }
    }
}