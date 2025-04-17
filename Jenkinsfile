pipeline {
    agent any

    environment {
        SERVER_PORT = "8081"
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "📥 Cloning public GitHub repository..."
                git branch: 'main', url: 'https://github.com/Annie-Christina-A/Spring_boot.git'
                sh 'ls -la'
            }
        }

        stage('Build Application') {
            steps {
                echo "🔨 Building Spring Boot project..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Stop Previous App') {
            steps {
                echo "🛑 Stopping previous instance if running..."
                sh '''
                    pkill -f "springboot-jenkins-app-0.0.1-SNAPSHOT.jar" || true
                '''
            }
        }

        stage('Run Application') {
            steps {
                echo "🚀 Starting application on port ${SERVER_PORT}..."
                sh '''
                    JAR_FILE=$(ls target/*.jar | head -n 1)
                    nohup java -jar $JAR_FILE \
                        --server.port=${SERVER_PORT} \
                        --server.address=0.0.0.0 > app.log 2>&1 &
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Application deployed successfully on port ${SERVER_PORT}"
        }
        failure {
            echo "❌ Deployment failed. Check logs and console output."
        }
    }
}
