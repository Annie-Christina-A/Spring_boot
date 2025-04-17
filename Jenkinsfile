pipeline {
    agent any
    environment {
        GITHUB_CREDENTIALS = credentials('github-id') // GitHub credentials stored in Jenkins
    }
    stages {
        stage('Clone Repository') {
            steps {
                script {
                    echo "Cloning the private GitHub repository..."
                    sh '''
                        git clone https://github.com/Annie-Christina-A/Spring_boot.git
                        
                    '''
                }
            }
        }
        stage('Build Application') {
            steps {
                script {
                    echo "Building the Spring Boot application..."
                    sh '''
                        mvn clean package
                        ls -la target/
                    '''
                }
            }
        }
        stage('Move JAR to Shared Directory') {
            steps {
                script {
                    echo "Moving the JAR file to shared directory for Windows access..."
                    sh '''
                        mkdir -p /mnt/c/jenkins-share/data
                        cp target/*.jar /mnt/c/jenkins-share/data/
                        ls -la /mnt/c/jenkins-share/data/
                    '''
                }
            }
        }
        stage('Restart Windows Service') {
            steps {
                script {
                    echo "Restarting Windows service hosting Spring Boot app..."
                    sh '''
                    cd /mnt/c/jenkins-share/data/
                    java -version
                    sudo /home/poc-user/start-spring.sh
                    '''
                }
            }
        }
    }
    post {
        success {
            echo "Deployment complete. Application is running and reverse proxied by IIS."
        }
        failure {
            echo "Pipeline failed. Please check logs."
        }
    }
}
