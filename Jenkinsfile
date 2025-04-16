pipeline {
    agent any

    environment {
        APP_NAME = "SpringBootApp"
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
                pgrep -f "target/.*.jar" | xargs kill -9 || true
                '''
            }
        }

        stage('Run Application') {
            steps {
                sh '''
                echo "Starting new application..."
                JAR_FILE=$(ls target/*.jar | head -n 1)
                chmod +x $JAR_FILE
                nohup java -jar $JAR_FILE --server.port=${SERVER_PORT} > app.log 2>&1 &
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Build and deployment successful! App is running on port ${SERVER_PORT}"
        }
        failure {
            echo "❌ Build failed. Check the console output for errors."
        }
    }
}
