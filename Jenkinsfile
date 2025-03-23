pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Annie-Christina-A/Spring_boot'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests -T 1C'
            }
        }

        stage('Deploy') {
            steps {
                sh 'java -jar target/*.jar'
            }
        }
    }
}



