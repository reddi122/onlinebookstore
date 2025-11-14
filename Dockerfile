# Use Tomcat with JRE 21 as base image
FROM tomcat:jre21

# Set working directory inside container
WORKDIR /usr/local/tomcat/webapps/

# Copy your built JAR/WAR from Jenkins workspace into Tomcat webapps
COPY onlinebookstore-1.0.0.jar ./onlinebookstore.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
