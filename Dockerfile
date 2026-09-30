# Build stage using Maven and Java 11
FROM maven:3.8.5-openjdk-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage using Tomcat 9 on Java 11
FROM tomcat:9.0-jdk11-openjdk-slim
COPY --from=build /app/target/TaskFlow.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]

