pipeline {
    agent any

    environment {
        APP_NAME = "SpringBootApp"
        SERVER_PORT = "8081"
        DATA_DIR = "data"
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "📥 Cloning the repository..."
                git branch: 'main', url: 'https://github.com/Annie-Christina-A/Spring_boot.git'
            }
        }

        stage('Setup Java and Maven') {
            steps {
                echo "🔍 Checking Java and Maven versions..."
                sh 'java -version'
                sh 'mvn -version'
            }
        }

        stage('Build Project') {
            steps {
                echo "🏗️ Building the Spring Boot application..."
                sh '''
                mvn clean package -DskipTests
                echo "✅ Build successful!"
                '''
            }
        }

        stage('Verify Build Artifacts') {
            steps {
                echo "📂 Checking the built JAR file..."
                sh '''
                echo "Current Directory: $(pwd)"
                echo "Listing files in target directory:"
                ls -lh target/
                '''
            }
        }

        stage('Move JAR to Data Directory') {
            steps {
                echo "📦 Moving JAR file to 'data' directory..."
                sh '''
                mkdir -p ${DATA_DIR}
                JAR_FILE=$(ls target/*.jar | head -n 1)
                if [ -f "$JAR_FILE" ]; then
                    mv $JAR_FILE ${DATA_DIR}/
                    echo "✅ JAR file moved successfully."
                else
                    echo "❌ ERROR: No JAR file found in target/ directory."
                    exit 1
                fi
                echo "Listing files in data directory:"
                ls -lh ${DATA_DIR}/
                '''
            }
        }

        stage('Stop Previous Instance') {
            steps {
                echo "🛑 Stopping old application instance..."
                sh '''
                OLD_PID=$(pgrep -f "${DATA_DIR}/.*.jar" || echo "")
                if [ ! -z "$OLD_PID" ]; then
                    kill -9 $OLD_PID
                    echo "✅ Old process ($OLD_PID) stopped."
                else
                    echo "ℹ️ No running instance found."
                fi
                '''
            }
        }

        stage('Run Application') {
            steps {
                echo "🚀 Starting new application..."
                sh '''
                JAR_FILE=$(ls ${DATA_DIR}/*.jar | head -n 1)
                if [ -f "$JAR_FILE" ]; then
                    chmod +x $JAR_FILE
                    nohup java -jar $JAR_FILE --server.port=${SERVER_PORT} > app.log 2>&1 &
                    echo "✅ Application started successfully!"
                else
                    echo "❌ ERROR: No JAR file found in data/ directory."
                    exit 1
                fi
                '''
            }
        }

        stage('Check Application Status') {
            steps {
                script {
                    sleep(5)  // Wait for the app to start
                    sh '''
                    echo "🔍 Checking if the application is running..."
                    STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:${SERVER_PORT})
                    if [ "$STATUS" == "200" ]; then
                        echo "✅ Application is running successfully!"
                    else
                        echo "❌ ERROR: Application is NOT accessible on port ${SERVER_PORT}."
                        exit 1
                    fi
                    '''
                }
            }
        }
    }

    post {
        success {
            script {
                echo "✅ Build and deployment successful! App is running on port ${SERVER_PORT}"
                sh '''
                echo "🌍 Access your application using:"
                echo "➡ Localhost: http://localhost:${SERVER_PORT}"
                echo "➡ Public URL (if firewall allows it): http://$(curl -s ifconfig.me):${SERVER_PORT}"
                '''
            }
        }
        failure {
            echo "❌ Build failed. Check the console output for errors."
        }
    }
}
