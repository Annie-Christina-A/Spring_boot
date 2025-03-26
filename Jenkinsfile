pipeline {
    agent any

    environment {
        APP_NAME = "SpringBootApp"
        SERVER_PORT = "8081"
        JAR_DIR = "target"
        APP_DIR = "data"
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    echo "📥 Cloning the repository..."
                    git branch: 'main', url: 'https://github.com/Annie-Christina-A/Spring_boot.git'
                    sh 'pwd'   // Print working directory
                    sh 'ls -la' // List cloned files
                }
            }
        }

        stage('Setup Java and Maven') {
            steps {
                script {
                    echo "🔧 Checking Java & Maven versions..."
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

        stage('Move JAR to Data Directory') {
            steps {
                script {
                    echo "📂 Moving JAR file to 'data' directory..."
                    sh '''
                        mkdir -p ${APP_DIR}  # Ensure 'data' directory exists
                        JAR_FILE=$(ls target/*.jar | head -n 1)
                        if [ -f "$JAR_FILE" ]; then
                            mv $JAR_FILE ${APP_DIR}/
                            echo "✅ JAR file moved to ${APP_DIR}/"
                            ls -lh ${APP_DIR}/  # Verify move
                        else
                            echo "❌ No JAR file found in target/. Build might have failed."
                            exit 1
                        fi
                    '''
                }
            }
        }

        stage('Stop Previous Instance') {
            steps {
                script {
                    echo "🛑 Stopping previous instance (if running)..."
                    sh '''
                        if [ -f app.pid ]; then
                            PID=$(cat app.pid)
                            if ps -p $PID > /dev/null; then
                                echo "Stopping process $PID..."
                                kill -9 $PID || true
                            else
                                echo "No running instance found."
                            fi
                            rm -f app.pid
                        fi
                    '''
                }
            }
        }

        stage('Run Application') {
            steps {
                script {
                    echo "🚀 Starting the application..."
                    sh '''
                        JAR_FILE=$(ls ${APP_DIR}/*.jar | head -n 1)
                        if [ -f "$JAR_FILE" ]; then
                            chmod +x $JAR_FILE
                            nohup java -jar $JAR_FILE --server.port=${SERVER_PORT} > ${APP_DIR}/app.log 2>&1 &
                            echo $! > app.pid  # Store process ID
                            echo "✅ Application started successfully!"
                            pwd  # Print the working directory after starting the app
                        else
                            echo "❌ No JAR file found in ${APP_DIR}/. Build might have failed."
                            exit 1
                        fi
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Build and deployment successful! App is running on port ${SERVER_PORT}"
        }
        failure {
            echo "❌ Build or execution failed. Check logs."
        }
    }
}
