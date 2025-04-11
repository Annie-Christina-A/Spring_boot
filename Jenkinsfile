pipeline {
  agent any

  environment {
    APP_REPO = "https://github.com/Annie-Christina-A/Spring_boot.git"
    APP_DIR = "springboot-app"
    EC2_USER = "ec2-user"
    EC2_IP = "13.60.9.77"  
    PEM_CRED_ID = "jenkins-ec2-pem"
  }

  stages {
    stage('Clone Spring Boot App') {
      steps {
        git url: "${env.APP_REPO}", branch: 'main'
        sh "mv * ${APP_DIR}"
      }
    }

    stage('Build App (Optional)') {
      steps {
        dir("${APP_DIR}") {
          sh './mvnw clean package -DskipTests'
        }
      }
    }

    stage('Deploy App to EC2') {
      steps {
        withCredentials([file(credentialsId: "${PEM_CRED_ID}", variable: 'PEM_PATH')]) {
          sh """
            chmod 400 $PEM_PATH
            scp -o StrictHostKeyChecking=no -i $PEM_PATH ${APP_DIR}/target/*.jar ${EC2_USER}@${EC2_IP}:/home/ec2-user/app.jar
            ssh -o StrictHostKeyChecking=no -i $PEM_PATH ${EC2_USER}@${EC2_IP} << 'EOF'
              nohup java -jar /home/ec2-user/app.jar > /home/ec2-user/app.log 2>&1 &
              echo "App started!"
            EOF
          """
        }
      }
    }
  }

  post {
    success {
      echo "✅ Spring Boot app deployed successfully!"
    }
    failure {
      echo "❌ Deployment failed!"
    }
  }
}
