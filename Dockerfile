FROM openjdk:8-alpine

# Required for starting application up.
RUN apk update && apk add /bin/sh

RUN mkdir -p /opt/app
ENV PROJECT_HOME /opt/app

COPY target/spring-boot-mongo-1.0.jar $PROJECT_HOME/spring-boot-mongo.jar

WORKDIR $PROJECT_HOME
EXPOSE 8080
RUN wget https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip && unzip newrelic-java.zip  
RUN cd newrelic 
ENV JAVA_OPTS="$JAVA_OPTS -javaagent:/home/ubuntu/newrelic/newrelic.jar"
ENV NEW_RELIC_APP_NAME="spring-boot-mongo"
ENV JAVA_OPTS="$JAVA_OPTS -Dnewrelic.config.app_name='spring-boot-mongo'"
ENV NEW_RELIC_LICENSE_KEY="c144e3ea6ada3343d248faffb6cbcadae1e7NRAL"
ENV JAVA_OPTS="$JAVA_OPTS -Dnewrelic.config.license_key='c144e3ea6ada3343d248faffb6cbcadae1e7NRAL'"
RUN java -javaagent:"/home/ubuntu/newrelic/newrelic.jar" "/var/lib/jenkins/workspace/automation/target/spring-boot-mongo-1.0.jar"
RUN mkdir -p /home/ubuntu/newrelic/logs
ENV NEW_RELIC_LOG_FILE_NAME=STDOUT
ENV JAVA_OPTS=-Dnewrelic.config.log_file_name=STDOUT
CMD ["java" ,"-jar","./spring-boot-mongo.jar"]
