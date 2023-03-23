FROM openjdk:8-alpine

# Required for starting application up.
RUN apk update && apk add /bin/sh

RUN mkdir -p /opt/app
ENV PROJECT_HOME /opt/app

COPY target/spring-boot-mongo-1.0.jar $PROJECT_HOME/spring-boot-mongo.jar

WORKDIR $PROJECT_HOME
EXPOSE 8080
RUN wget https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY=NRAK-KHSC73ZQ3DXSJA5W8TZREHFDMEV NEW_RELIC_ACCOUNT_ID=3789883 /usr/local/bin/newrelic install -n java-agent-installer  
CMD ["java" ,"-jar","./spring-boot-mongo.jar"]
