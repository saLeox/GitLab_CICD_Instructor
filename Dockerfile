FROM maven:3.5-jdk-8 AS build  
COPY src /usr/src/app/src  
COPY pom.xml /usr/src/app  
RUN mvn -f /usr/src/app/pom.xml clean package

FROM java:8
VOLUME /tmp
COPY --from=build /usr/src/app/target/microservicecloud.jar /usr/app/appointment-service-8081.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/usr/app/appointment-service-8081.jar"]