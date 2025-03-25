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
                sh '''
                echo "Building the project..."
                mvn clean package -DskipTests
                
                echo "Current Directory:"
                pwd

                echo "Listing files in target directory:"
                ls -l target/
                '''
            }
        }

        stage('Move JAR to Data Directory') {
            steps {
                sh '''
                echo "Creating data directory if not exists..."
                mkdir -p ${DATA_DIR}

                echo "Moving JAR file to data directory..."
                JAR_FILE=$(ls target/*.jar | head -n 1)
                if [ -f "$JAR_FILE" ]; then
                    mv $JAR_FILE ${DATA_DIR}/
                    echo "JAR file moved successfully."
                else
                    echo "❌ ERROR: No JAR file found in target/ directory."
                    exit 1
                fi

                echo "Listing files in data directory:"
                ls -l ${DATA_DIR}/
                '''
            }
        }

        stage('Stop Previous Instance') {
            steps {
                sh '''
                echo "Stopping old application (if running)..."
                OLD_PID=$(pgrep -f "${DATA_DIR}/.*.jar" || echo "")
                if [ ! -z "$OLD_PID" ]; then
                    kill -9 $OLD_PID
                    echo "Old process ($OLD_PID) stopped."
                else
                    echo "No running instance found."
                fi
                '''
            }
        }

        stage('Run Application') {
            steps {
                sh '''
                echo "Starting new application..."
                
                JAR_FILE=$(ls ${DATA_DIR}/*.jar | head -n 1)
                if [ -f "$JAR_FILE" ]; then
                    chmod +x $JAR_FILE
                    nohup java -jar $JAR_FILE --server.port=${SERVER_PORT} > app.log 2>&1 &
                    disown
                    echo "Application started successfully!"
                else
                    echo "❌ ERROR: No JAR file found in data/ directory."
                    exit 1
                fi
                '''
            }
        }
    }

    post {
        success {
            script {
                echo "✅ Build and deployment successful! App is running on port ${SERVER_PORT}"
                sh '''
                echo "Access your application using:"
                echo "Localhost: http://localhost:${SERVER_PORT}"
                echo "Public URL (if firewall allows it): http://$(curl -s ifconfig.me):${SERVER_PORT}"
                '''
            }
        }
        failure {
            echo "❌ Build failed. Check the console output for errors."
        }
    }
}
