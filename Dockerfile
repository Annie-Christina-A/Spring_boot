FROM maven:3.6.3-openjdk-17 AS build
WORKDIR app
COPY . .
RUN mvn clean package -DskipTests
# Stage 2: Run the application
 FROM openjdk:17-jdk-alpine
 WORKDIR app
 COPY --from=build /app/target/*.jar app.jar
 EXPOSE 8080
 ENTRYPOINT ["java", "-jar", "app.jar"]

