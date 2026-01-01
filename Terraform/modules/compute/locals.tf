locals {
  servers = {
    ansible_master = { name = "ansible-master" }
    sonarqube      = { name = "sonarqube" }
    nexus          = { name = "nexus" }
    jenkins_docker = { name = "jenkins-docker" }
  }
}
