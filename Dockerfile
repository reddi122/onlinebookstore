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

#FROM tomcat:jre21

# Install curl for downloading artifact
#RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Artifact URL passed through Jenkins
#ARG ARTIFACT_URL

# Download WAR from Nexus
#RUN curl -L -o /usr/local/tomcat/webapps/onlinebookstore.war "${ARTIFACT_URL}"

#EXPOSE 8080
#CMD ["catalina.sh", "run"]


#FROM tomcat:jre21

#COPY onlinebookstore.war /usr/local/tomcat/webapps/

#EXPOSE 8080
#CMD ["catalina.sh", "run"]

#FROM tomcat:11.0.14-jdk21-temurin

# Clean default apps (optional)
#RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy your WAR
#COPY onlinebookstore.war /usr/local/tomcat/webapps/ROOT.war

#EXPOSE 8080
#CMD ["catalina.sh", "run"]

#FROM tomcat:9.0-jdk17
 
# Clean default ROOT webapp
#RUN rm -rf /usr/local/tomcat/webapps/*
 
# Copy your WAR file from Jenkins into the Tomcat webapps folder
#COPY target/*.war /usr/local/tomcat/webapps/
 
#EXPOSE 8080
 
#CMD ["catalina.sh", "run"]


#FROM tomcat:9.0-jdk17

# Remove default Tomcat apps
#RUN rm -rf /usr/local/tomcat/webapps/*

# Build arguments from Jenkins
#ARG NEXUS_URL
#ARG NEXUS_REPO
#ARG GROUP_ID=onlinebookstore
#ARG ARTIFACT_ID=onlinebookstore
#ARG VERSION

# Download WAR directly from Nexus
#ADD http://${NEXUS_URL}/repository/${NEXUS_REPO}/${GROUP_ID}/${ARTIFACT_ID}/${VERSION}/${ARTIFACT_ID}-${VERSION}.war \
 #   /usr/local/tomcat/webapps/ROOT.war

#EXPOSE 8080

#CMD ["catalina.sh", "run"]


#FROM tomcat:9.0-jdk17

#RUN rm -rf /usr/local/tomcat/webapps/*

#RUN apt-get update && apt-get install -y maven curl && rm -rf /var/lib/apt/lists/*

#ARG NEXUS_URL
#ARG VERSION
#ARG GROUP_ID=onlinebookstore
#ARG ARTIFACT_ID=onlinebookstore

#RUN mvn dependency:get \
 # -DremoteRepositories=nexus::default::http://${NEXUS_URL}/repository/maven-snapshots \
  #-DgroupId=${GROUP_ID} \
  #-DartifactId=${ARTIFACT_ID} \
  #-Dversion=${VERSION} \
  #-Dpackaging=war \
  #-Ddest=/usr/local/tomcat/webapps/ROOT.war

#EXPOSE 8080
#CMD ["catalina.sh", "run"]

FROM tomcat:9.0-jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

RUN apt-get update && apt-get install -y maven curl && rm -rf /var/lib/apt/lists/*

ARG NEXUS_URL
ARG VERSION
ARG GROUP_ID=onlinebookstore
ARG ARTIFACT_ID=onlinebookstore
ARG NEXUS_USER
ARG NEXUS_PASS

# Create Maven settings.xml safely
RUN mkdir -p /root/.m2 && \
    cat > /root/.m2/settings.xml <<EOF
<settings>
  <servers>
    <server>
      <id>nexus</id>
      <username>${NEXUS_USER}</username>
      <password>${NEXUS_PASS}</password>
    </server>
  </servers>
</settings>
EOF

RUN mvn dependency:copy \
  -Dartifact=${GROUP_ID}:${ARTIFACT_ID}:${VERSION}:war \
  -DoutputDirectory=/usr/local/tomcat/webapps \
  -DdestFileName=ROOT.war \
  -DrepoUrl=http://${NEXUS_URL}/repository/maven-snapshots \
  -DrepositoryId=nexus \
  -Dtransitive=false

EXPOSE 8080
CMD ["catalina.sh", "run"]


