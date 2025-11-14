# Use Tomcat with JRE 21 as base image
FROM tomcat:jre21

# Set working directory inside container
WORKDIR /usr/local/tomcat/webapps/

# Copy WAR file built by Maven
COPY target/onlinebookstore.war ./onlinebookstore.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
