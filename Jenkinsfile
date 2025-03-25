pipeline {
    agent any

    environment {
        APP_NAME = "SpringBootApp"
        SERVER_PORT = "8081"
        REPO_URL = "https://github.com/Annie-Christina-A/Spring_boot.git"
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "📥 Cloning repository..."
                git branch: 'main', url: "${REPO_URL}"
            }
        }

        stage('Setup Java and Maven') {
            steps {
                echo "🔍 Verifying Java and Maven..."
                sh 'java -version'
                sh 'mvn -version'
            }
        }

        stage('Cleanup (Optional)') {
            steps {
                echo "🧹 Cleaning previous builds..."
                sh 'rm -rf target/*.jar || true'
            }
        }

        stage('Build Project') {
            steps {
                echo "🏗️ Building the project..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Stop Previous Instance') {
            steps {
                echo "🛑 Stopping old application (if running)..."
                sh '''
                OLD_PID=$(pgrep -f 'java.*jar' || echo "")
                if [ ! -z "$OLD_PID" ]; then
                    echo "Stopping process $OLD_PID..."
                    kill -9 $OLD_PID
                else
                    echo "No running instance found."
                fi
                '''
            }
        }

        stage('Run Application') {
            steps {
                echo "🚀 Starting new application..."
                sh '''
                JAR_FILE=$(ls -1 target/*.jar | head -n 1)
                chmod +x $JAR_FILE
                nohup java -jar $JAR_FILE --server.port=${SERVER_PORT} > app.log 2>&1 &
                echo "Application started successfully!"
                '''
            }
        }

        stage('Check Application Status') {
            steps {
                echo "🔍 Verifying application status..."
                sleep 5
                script {
                    def status = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:${SERVER_PORT}", returnStdout: true).trim()
                    if (status == "200") {
                        echo "✅ Application is running successfully on port ${SERVER_PORT}!"
                    } else {
                        error "❌ Application failed to start. Check logs in app.log."
                    }
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment successful! App is live on port ${SERVER_PORT}!"
        }
        failure {
            echo "❌ Build or deployment failed. Check logs."
        }
    }
}
