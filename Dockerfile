# Build stage using Maven and Java 8
FROM maven:3.8.5-openjdk-8 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage using Tomcat 9 on Java 8
FROM tomcat:9.0-jdk8-openjdk-slim
COPY --from=build /app/target/JFSD.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
