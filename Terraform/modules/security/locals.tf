locals {
  servers = {
    ansible_master = { ports = [] }
    sonarqube      = { ports = [9000] }
    nexus          = { ports = [8081] }
    jenkins_docker = { ports = [8080, 8082] }
  }
}
