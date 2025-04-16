pipeline {
    agent any

    environment {
        JAR_NAME = ''
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/anniechr/spring-boot-hello-world-example.git', branch: 'main'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('Prepare JAR File') {
            steps {
                script {
                    JAR_NAME = sh(script: "ls target/*.jar | grep -v 'original' | head -n 1", returnStdout: true).trim()
                    echo "Using JAR: ${JAR_NAME}"
                }
            }
        }

        stage('Stop Previous App') {
            steps {
                script {
                    sh """
                        PID=\$(lsof -t -i:8081)
                        if [ ! -z "\$PID" ]; then
                            echo "Killing existing process on port 8081 (PID: \$PID)"
                            kill -9 \$PID
                        else
                            echo "No process running on port 8081"
                        fi
                    """
                }
            }
        }

        stage('Run Spring Boot App') {
            steps {
                script {
                    sh """
                        nohup java -jar ${JAR_NAME} --server.port=8081 > springboot.log 2>&1 &
                        sleep 10
                        echo "Checking if application started..."
                        ps aux | grep java
                    """
                }
            }
        }

        stage('Test App Endpoint') {
            steps {
                sh 'curl -v http://localhost:8081 || true'
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution finished.'
        }
    }
}
