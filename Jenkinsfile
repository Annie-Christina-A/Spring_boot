pipeline {
    agent any

    environment {
        REPO_URL = "https://github.com/Annie-Christina-A/Spring_boot.git"
        BRANCH = "main"
        APP_DIR = "data"
        SERVER_PORT = "8081"
        PEM_FILE = "jenkins-ec2.pem"                // Your private key to access EC2
        EC2_USER = "ec2-user"                       // Default user for Amazon Linux
        EC2_HOST = "13.60.9.77"           // Replace with actual IP or fetch from Terraform output
        REMOTE_APP_DIR = "/home/ec2-user/app"       // Directory on EC2 to store and run app
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: "${BRANCH}", url: "${REPO_URL}"
            }
        }

        stage('Build Project') {
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

        stage('Copy JAR to EC2') {
            steps {
                sh '''
                    chmod 600 ${PEM_FILE}
                    ssh -o StrictHostKeyChecking=no -i ${PEM_FILE} ${EC2_USER}@${EC2_HOST} "mkdir -p ${REMOTE_APP_DIR}"
                    scp -i ${PEM_FILE} ${APP_DIR}/*.jar ${EC2_USER}@${EC2_HOST}:${REMOTE_APP_DIR}/
                '''
            }
        }

        stage('Run Application on EC2') {
            steps {
                sh '''
                    ssh -o StrictHostKeyChecking=no -i ${PEM_FILE} ${EC2_USER}@${EC2_HOST} << EOF
                    pkill -f "java -jar" || true
                    nohup java -jar ${REMOTE_APP_DIR}/*.jar --server.port=${SERVER_PORT} > ${REMOTE_APP_DIR}/app.log 2>&1 &
                    echo "App started at http://${EC2_HOST}:${SERVER_PORT}"
                    EOF
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Spring Boot app deployed and running on EC2 at http://${EC2_HOST}:${SERVER_PORT}"
        }
        failure {
            echo "❌ Deployment failed. Check logs and SSH access."
        }
    }
}
