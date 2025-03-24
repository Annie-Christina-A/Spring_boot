pipeline {
    agent any

    environment {
        APP_NAME = "SpringBootApp"
        JAR_NAME = "target/*.jar"
        SERVER_PORT = "8081"  
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Annie-Christina-A/Spring_boot.git'
            }
        }

        stage('Setup Java and Maven') {
            steps {
                sh 'java -version'
                sh 'mvn -version'
            }
        }

        stage('Build Project') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Stop Previous Instance') {
            steps {
                sh '''
                echo "Stopping old application (if running)..."
                pkill -f "java -jar" || true
                '''
            }
        }

        stage('Run Application') {
            steps {
                sh '''
                echo "Starting new application..."
                nohup java -jar ${JAR_NAME} > app.log 2>&1 &
                '''
            }
        }
    }

    post {
        success {
            echo "Build and deployment successful! App is running on port ${SERVER_PORT}"
        }
        failure {
            echo "Build failed. Check the console output for errors."
        }
    }
}

