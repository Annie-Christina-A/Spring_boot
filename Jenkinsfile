pipeline {
    agent any

    environment {
        JAR_NAME = "spring-boot-hello-world-example-0.0.1-SNAPSHOT.jar"
        APP_DIR = "data"
        PORT = "8081"
    }

    stages {
        stage('Checkout Repository') {
            steps {
                echo "📥 Cloning the repository..."
                checkout scm
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
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Verify Build Artifacts') {
            steps {
                echo "📂 Checking the built JAR file..."
                sh "ls -lh target/"
            }
        }

        stage('Move JAR to Data Directory') {
            steps {
                script {
                    sh "mkdir -p ${APP_DIR}"
                    sh "mv target/${JAR_NAME} ${APP_DIR}/"
                    echo "✅ JAR file moved successfully."
                }
            }
        }

        stage('Stop Previous Instance') {
            steps {
                script {
                    def oldPid = sh(script: "pgrep -f ${APP_DIR}/${JAR_NAME}", returnStdout: true).trim()
                    if (oldPid) {
                        echo "🛑 Stopping old application instance (PID: ${oldPid})..."
                        sh "kill -9 ${oldPid}"
                    } else {
                        echo "ℹ️ No running instance found."
                    }
                }
            }
        }

        stage('Run Application') {
            steps {
                script {
                    echo "🚀 Starting new application..."
                    sh "chmod +x ${APP_DIR}/${JAR_NAME}"
                    sh "nohup java -jar ${APP_DIR}/${JAR_NAME} --server.port=${PORT} > ${APP_DIR}/app.log 2>&1 &"
                    echo "✅ Application started successfully!"
                }
            }
        }

        stage('Check Application Status') {
            steps {
                script {
                    echo "🔍 Checking if the application is running..."
                    sleep 5
                    def status = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:${PORT}", returnStdout: true).trim()
                    if (status == "200") {
                        echo "✅ Application is running successfully on port ${PORT}!"
                    } else {
                        error "❌ Application failed to start. Check logs in ${APP_DIR}/app.log."
                    }
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Build and deployment successful!"
        }
        failure {
            echo "❌ Build or deployment failed. Check logs!"
        }
    }
}
