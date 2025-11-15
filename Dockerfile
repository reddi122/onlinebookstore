# Use Tomcat with JRE 21 as base image
#FROM tomcat:jre21

# Set working directory inside container
#WORKDIR /usr/local/tomcat/webapps/

# Copy WAR file built by Maven
#COPY target/onlinebookstore.war ./onlinebookstore.war

# Expose Tomcat port
#EXPOSE 8080

# Start Tomcat
#CMD ["catalina.sh", "run"]

FROM tomcat:jre21

# Install curl for downloading artifact
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Artifact URL passed through Jenkins
ARG ARTIFACT_URL

# Download WAR from Nexus
RUN curl -L -o /usr/local/tomcat/webapps/onlinebookstore.war "${ARTIFACT_URL}"

EXPOSE 8080
CMD ["catalina.sh", "run"]


