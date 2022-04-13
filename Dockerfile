FROM openjdk:11-jre-slim

ENV APP_PORT=8070
ENV JWT_SECRET_KEY="1wHqQFdUlUr5TZNr1wTCiuyM0Vye2L4jXX1wHqQFdUlUr5TZNr1wTCiuyM0Vye2L4jXX"

COPY user-microservice/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]

