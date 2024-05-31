output "jenkins_url" {
  value = "http://${aws_instance.jenkins_server.public_ip}:8080"
}