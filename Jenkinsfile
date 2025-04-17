pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                echo "Cloning the GitHub repository..."
                git branch: 'main', url: 'https://github.com/Annie-Christina-A/Spring_boot.git'
            }
        }

        stage('Build Application') {
            steps {
                echo "Building the Spring Boot application with Maven..."
                bat '''
                    
                    mvn clean package
                '''
            }
        }

        stage('Move JAR to Shared Directory') {
            steps {
                echo "Moving the JAR file to shared directory..."
                bat '''
                    mkdir "C:\\jenkins-share\\data"
                    copy "target\\spring-boot-hello-world-example-0.0.1-SNAPSHOT.jar" "C:\\jenkins-share\\data\\"
                '''
            }
        }

        stage('Copy Deployment Script') {
            steps {
                echo "Copying jenkinpipeline.bat to shared directory..."
                bat '''
                    copy "jenkinpipeline.bat" "C:\\jenkins-share\\data\\"
                '''
            }
        }

        stage('Restart Windows Service') {
            steps {
                echo "Running the batch script to restart the Spring Boot app..."
                bat '''
                    cd "C:\\jenkins-share\\data"
                    call jenkinpipeline.bat
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment complete. Application is running and reverse proxied by IIS."
        }
        failure {
            echo "❌ Pipeline failed. Please check logs."
        }
    }
}
