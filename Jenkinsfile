pipeline {
    agent any

    tools {
        jdk 'java'
        maven 'maven'
    }

    environment {
        DOCKER_IMAGE = "reddi122/onlinebookstore-java:${BUILD_NUMBER}"

        NEXUS_URL = "54.210.92.84:8082"
        NEXUS_REPO = "maven-snapshots"       // Using SNAPSHOT repo
        NEXUS_CREDENTIALS = "nexus-creds"

        SONAR_TOKEN = credentials('sonar-token')
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/reddi122/onlinebookstore.git'
            }
        }

        stage('Set Unique Version') {
            steps {
                sh """
                    mvn versions:set -DnewVersion=1.0.${BUILD_NUMBER}-SNAPSHOT
                    mvn versions:commit

                    echo "Using Version:"
                    mvn help:evaluate -Dexpression=project.version -q -DforceStdout
                """
            }
        }

        stage('Build Code') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                sh """
                    mvn sonar:sonar \
                    -Dsonar.projectKey=onlinebookstore-java \
                    -Dsonar.host.url=http://54.210.92.84:8081/ \
                    -Dsonar.login=${SONAR_TOKEN}
                """
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Upload to Nexus (SNAPSHOT)') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${NEXUS_CREDENTIALS}",
                    usernameVariable: 'NEXUS_USER',
                    passwordVariable: 'NEXUS_PASS'
                )]) {
                    sh """
                        mvn deploy -DskipTests \
                        -DaltDeploymentRepository=${NEXUS_REPO}::default::http://${NEXUS_USER}:${NEXUS_PASS}@${NEXUS_URL}/repository/${NEXUS_REPO}
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-id', url: '']) {
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Pipeline Success! Docker Image pushed: ${DOCKER_IMAGE}"
        }
        failure {
            echo "❌ Pipeline Failed!"
        }
    }
}
