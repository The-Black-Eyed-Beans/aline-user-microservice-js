FROM openjdk:11-jre-slim

ENV APP_PORT=8070

COPY user-microservice/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]

