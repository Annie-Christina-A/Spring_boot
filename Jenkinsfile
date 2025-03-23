pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Annie-Christina-A/Spring_boot.git'
            }
        }
        
        stage('Build Project') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Run Application') {
            steps {
                sh 'nohup java -jar target/*.jar &'
            }
        }
    }
}
