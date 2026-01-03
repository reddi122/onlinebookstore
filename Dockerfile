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

#FROM tomcat:9.0-jdk17

#RUN rm -rf /usr/local/tomcat/webapps/*

#RUN apt-get update && apt-get install -y maven curl && rm -rf /var/lib/apt/lists/*

#ARG NEXUS_URL
#ARG VERSION
#ARG GROUP_ID=onlinebookstore
#ARG ARTIFACT_ID=onlinebookstore
#ARG NEXUS_USER
#ARG NEXUS_PASS

# Maven settings with Nexus credentials
#RUN mkdir -p /root/.m2 && \
#    cat > /root/.m2/settings.xml <<EOF
#<settings>
 # <servers>
 #   <server>
 #     <id>nexus</id>
  #    <username>${NEXUS_USER}</username>
   #   <password>${NEXUS_PASS}</password>
    #</server>
  #</servers>
#</settings>
#EOF

# ✅ CORRECT SNAPSHOT DOWNLOAD
#RUN mvn dependency:copy \
 # -Dartifact=${GROUP_ID}:${ARTIFACT_ID}:${VERSION}:war \
  #-DoutputDirectory=/usr/local/tomcat/webapps \
 # -DdestFileName=ROOT.war \
#  -DremoteRepositories=nexus::default::http://${NEXUS_URL}/repository/maven-snapshots \
#  -Dtransitive=false

#EXPOSE 8080
#CMD ["catalina.sh", "run"]



 #==============================
 #STAGE 1 — DOWNLOAD ARTIFACT
 #==============================
#FROM maven:3.9.6-eclipse-temurin-17 AS downloader

#ARG NEXUS_URL
#ARG VERSION
#ARG GROUP_ID=onlinebookstore
#ARG ARTIFACT_ID=onlinebookstore
#ARG NEXUS_USER
#ARG NEXUS_PASS

# Create Maven settings with Nexus credentials (temporary)
#RUN mkdir -p /root/.m2 && \
   # cat > /root/.m2/settings.xml <<EOF
#<settings>
 # <servers>
  #  <server>
   #   <id>nexus</id>
    #  <username>${NEXUS_USER}</username>
     # <password>${NEXUS_PASS}</password>
   # </server>
  #</servers>
#</settings>
#EOF

# Download artifact from Nexus
#RUN mvn dependency:copy \
 # -Dartifact=${GROUP_ID}:${ARTIFACT_ID}:${VERSION}:war \
  #-DoutputDirectory=/artifact \
  #-DdestFileName=ROOT.war \
  #-DremoteRepositories=nexus::default::http://${NEXUS_URL}/repository/poc1-snapshots \
  #-Dtransitive=false

# ==============================
# STAGE 2 — RUNTIME IMAGE
# ==============================
#FROM tomcat:9.0-jdk17

# Clean default apps
#RUN rm -rf /usr/local/tomcat/webapps/*

# Copy ONLY the WAR (no Maven, no credentials)
#COPY --from=downloader /artifact/ROOT.war /usr/local/tomcat/webapps/ROOT.war

#EXPOSE 8080
#CMD ["catalina.sh", "run"]

# ==============================
# STAGE 1 — DOWNLOAD ARTIFACT
# ==============================
FROM maven:3.9.6-eclipse-temurin-17 AS downloader

ARG NEXUS_URL
ARG VERSION
ARG GROUP_ID=onlinebookstore
ARG ARTIFACT_ID=onlinebookstore
ARG NEXUS_USER
ARG NEXUS_PASS

RUN mkdir -p /root/.m2 /artifact

# ✅ NO HEREDOC → NO EMPTY FILE ISSUE
RUN printf '<settings>\n\
  <mirrors>\n\
    <mirror>\n\
      <id>allow-http</id>\n\
      <mirrorOf>external:http:*</mirrorOf>\n\
      <url>http://%s</url>\n\
    </mirror>\n\
  </mirrors>\n\
  <servers>\n\
    <server>\n\
      <id>nexus</id>\n\
      <username>%s</username>\n\
      <password>%s</password>\n\
    </server>\n\
  </servers>\n\
</settings>' "$NEXUS_URL" "$NEXUS_USER" "$NEXUS_PASS" > /root/.m2/settings.xml

RUN mvn dependency:get \
    -Dartifact=${GROUP_ID}:${ARTIFACT_ID}:${VERSION}:war \
    -DremoteRepositories=nexus::default::http://${NEXUS_URL}/repository/poc1-snapshots \
    -Dmaven.repo.local=/tmp/m2 && \
    cp /tmp/m2/onlinebookstore/onlinebookstore/${VERSION}/*.war /artifact/ROOT.war

# ==============================
# STAGE 2 — RUNTIME IMAGE
# ==============================
FROM tomcat:9.0-jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=downloader /artifact/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
