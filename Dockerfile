FROM openjdk:8-alpine

# Required for starting application up.
RUN apk update && apk add /bin/sh

RUN mkdir -p /opt/app
ENV PROJECT_HOME /opt/app

COPY target/spring-boot-mongo-1.0.jar $PROJECT_HOME/spring-boot-mongo.jar

WORKDIR $PROJECT_HOME
EXPOSE 8080
RUN wget https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip && unzip newrelic-java.zip  /app
ADD spring-boot-mongo-1.0.jar /app
ADD newrelic.jar  /app
ADD newrelic.yml  /app 
ENV NEW_RELIC_APP_NAME="spring-boot-mongo"
ENV NEW_RELIC_LICENSE_KEY="c144e3ea6ada3343d248faffb6cbcadae1e7NRAL"
ENV NEW_RELIC_LOG_FILE_NAME="STDOUT"
ENTRYPOINT ["java" ,"-jar","./spring-boot-mongo.jar","java","-javaagent:/app/newrelic.jar","-jar","/app/spring-boot-mongo-1.0.jar"]
