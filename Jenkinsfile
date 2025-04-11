pipeline {
    agent any

    environment {
        REPO_URL = "https://github.com/Annie-Christina-A/Spring_boot.git"
        BRANCH = "main"
        PEM_FILE = "jenkins-ec2.pem"               // Make sure this key is already in Jenkins workspace
        EC2_USER = "ec2-user"                      // Amazon Linux default user
        EC2_HOST = "13.60.9.77"          // Replace with public IP from your Terraform output
        APP_DIR = "data"
        SERVER_PORT = "8081"
        REMOTE_APP_DIR = "/home/ec2-user/app"
    }

    stages {

        stage('Clone Application Repo') {
            steps {
                git branch: "${BRANCH}", url: "${REPO_URL}"
            }
        }

        stage('Build Spring Boot App') {
            steps {
                sh '''
                    mvn clean package -DskipTests
                '''
            }
        }

        stage('Prepare JAR') {
            steps {
                sh '''
                    mkdir -p ${APP_DIR}
                    JAR_FILE=$(ls target/*.jar | head -n 1)
                    cp $JAR_FILE ${APP_DIR}/
                '''
            }
        }

        stage('Transfer JAR to EC2') {
            steps {
                sh '''
                    chmod 600 ${PEM_FILE}
                    ssh -o StrictHostKeyChecking=no -i ${PEM_FILE} ${EC2_USER}@${EC2_HOST} "mkdir -p ${REMOTE_APP_DIR}"
                    scp -i ${PEM_FILE} ${APP_DIR}/*.jar ${EC2_USER}@${EC2_HOST}:${REMOTE_APP_DIR}/
                '''
            }
        }

        stage('Run App on EC2') {
            steps {
                sh '''
                    ssh -o StrictHostKeyChecking=no -i ${PEM_FILE} ${EC2_USER}@${EC2_HOST} << EOF
                    pkill -f "java -jar" || true
                    nohup java -jar ${REMOTE_APP_DIR}/*.jar --server.port=${SERVER_PORT} > ${REMOTE_APP_DIR}/app.log 2>&1 &
                    echo "App deployed at http://${EC2_HOST}:${SERVER_PORT}"
                    EOF
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Spring Boot app deployed successfully on EC2 at http://${EC2_HOST}:${SERVER_PORT}"
        }
        failure {
            echo "❌ Deployment failed. Check EC2 SSH access and logs."
        }
    }
}
