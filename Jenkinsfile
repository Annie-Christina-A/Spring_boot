pipeline {
    agent any

    environment {
        APP_NAME = "springbootapp"
        SERVER_PORT = "8081"
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    echo "📥 Cloning the repository..."
                    git branch: 'main', url: 'https://github.com/Annie-Christina-A/Spring_boot.git'
                    sh 'pwd'
                    sh 'ls -la'
                }
            }
        }

        stage('Setup Java and Maven') {
            steps {
                script {
                    echo "🔧 Checking Java & Maven..."
                    sh 'java -version'
                    sh 'mvn -version'
                }
            }
        }

        stage('Build Project') {
            steps {
                script {
                    echo "🏗️ Building the Spring Boot project..."
                    sh '''
                        mvn clean package -DskipTests
                        ls -lh target/
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Building Docker image..."
                    sh '''
                        docker build -t ${APP_NAME}:latest .
                        docker images | grep ${APP_NAME}
                    '''
                }
            }
        }

        stage('Stop & Remove Previous Container') {
            steps {
                script {
                    echo "🛑 Cleaning up old Docker containers..."
                    sh '''
                        docker stop ${APP_NAME} || true
                        docker rm ${APP_NAME} || true
                    '''
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    echo "🚀 Running the Docker container..."
                    sh '''
                        docker run -d --name ${APP_NAME} -p ${SERVER_PORT}:${SERVER_PORT} ${APP_NAME}:latest
                        docker ps | grep ${APP_NAME}
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Build and deployment successful! Docker container is running on port ${SERVER_PORT}"
        }
        failure {
            echo "❌ Something went wrong. Check logs above for errors."
        }
    }
}
