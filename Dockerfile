FROM openjdk:8-alpine

# Required for starting application up.
RUN apk update && apk add /bin/sh

RUN mkdir -p /opt/app
ENV PROJECT_HOME /opt/app

COPY target/spring-boot-mongo-1.0.jar $PROJECT_HOME/spring-boot-mongo.jar

WORKDIR $PROJECT_HOME
EXPOSE 8080
# Set environment variables
ENV NEW_RELIC_LICENSE_KEY=c144e3ea6ada3343d248faffb6cbcadae1e7NRAL
ENV NEW_RELIC_APP_NAME=spring-boot-mongo

# Download and install New Relic agent
RUN mkdir /newrelic && \
    cd /newrelic && \
    curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic.jar && \
    curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic.yml && \
    sed -i 's/app_name: spring-boot-mongo/app_name: ${NEW_RELIC_APP_NAME}/g' newrelic.yml && \
    sed -i 's/license_key: c144e3ea6ada3343d248faffb6cbcadae1e7NRAL/license_key: ${NEW_RELIC_LICENSE_KEY}/g' newrelic.yml

# Set New Relic as a JVM argument
ENV JAVA_TOOL_OPTIONS="-javaagent:/newrelic/newrelic.jar"

# Copy your Java application code into the container
COPY . /app

# Set the working directory to the application directory
WORKDIR /app

# Compile your Java application
RUN javac Main.java

# Expose the application port
EXPOSE 8080

# Start the application
CMD ["java", "Main"]
CMD ["java" ,"-jar","./spring-boot-mongo.jar"]
