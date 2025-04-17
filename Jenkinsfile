pipeline {
    agent any

    environment {
        SERVER_PORT = "8081"
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone your Spring Boot repo
                git 'https://github.com/Annie-Christina-A/Spring_boot.git'
            }
        }

        stage('Build Project') {
            steps {
                // Build the project with Maven
                sh 'mvn clean package -DskipTests'
            }
        }


        stage('Run Application') {
            steps {
                // Start the app on port 8081 and bind to all network interfaces
                sh '''
                echo "Starting app on port ${SERVER_PORT}..."
                JAR_FILE=$(ls target/*.jar | head -n 1)
                nohup java -jar $JAR_FILE --server.port=${SERVER_PORT} --server.address=0.0.0.0 > app.log 2>&1 &
                '''
            }
        }
    }

    post {
        success {
            echo "✅ App is running on port ${SERVER_PORT}"
        }
        failure {
            echo "❌ Something went wrong. Check logs."
        }
    }
}
