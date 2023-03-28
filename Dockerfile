FROM openjdk:8-alpine

# Required for starting application up.
#RUN apk update && apk add /bin/sh && yum -y install unzip


RUN mkdir -p /opt/app
ENV PROJECT_HOME /opt/app

RUN wget https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip && unzip newrelic-java.zip
ADD newrelic /opt/app/newrelic

ENV NEW_RELIC_APP_NAME="spring-boot-mongo"
ENV NEW_RELIC_LICENSE_KEY="c144e3ea6ada3343d248faffb6cbcadae1e7NRAL"
ENV NEW_RELIC_LOG_FILE_NAME="STDOUT"

COPY target/spring-boot-mongo-1.0.jar $PROJECT_HOME/spring-boot-mongo.jar

WORKDIR $PROJECT_HOME
EXPOSE 8080
ENTRYPOINT ["java","-javaagent:/opt/app/newrelic/newrelic.jar","-jar","/opt/app/spring-boot-mongo.jar"]
#CMD ["java" ,"-jar","./spring-boot-mongo.jar"]

