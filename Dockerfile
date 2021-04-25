# mvn build
FROM maven:3.5-jdk-8 AS build  
COPY src /usr/src/app/src  
COPY pom.xml /usr/src/app  
RUN mvn -f /usr/src/app/pom.xml clean package

# run to generate multi stage 
FROM openjdk:8-jre-alpine as builder
WORKDIR application
COPY --from=build /usr/src/app/target/*.jar application.jar
RUN java -Djarmode=layertools -jar application.jar extract
#ENTRYPOINT ["java", "-jar", "/usr/app/appointment-service-8081.jar"]

# extract
FROM openjdk:8-jre-alpine
WORKDIR application
VOLUME /tmp
COPY --from=builder application/dependencies/ ./
COPY --from=builder application/snapshot-dependencies/ ./
COPY --from=builder application/spring-boot-loader/ ./
COPY --from=builder application/application/ ./
EXPOSE 8081
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
