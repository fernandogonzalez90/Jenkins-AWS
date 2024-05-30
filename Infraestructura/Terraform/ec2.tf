resource "null_resource" "wait_for_instance" {
  provisioner "local-exec" {
    command = "echo Waiting for instance to be ready..."
  }

  depends_on = [aws_instance.jenkins_server]
}



resource "aws_instance" "jenkins_server" {
  ami           = "ami-058bd2d568351da34" # Debian 12
  instance_type = "t2.micro"
  key_name      = "jenkins_key"

  security_groups = [aws_security_group.jenkins_sg.name]

  tags = {
    Name = "JenkinsServer"
  }

  provisioner "local-exec" {
    command = <<-EOT
      sleep 60  # Espera 60 segundos antes de ejecutar los comandos
      echo "[jenkins_server]
      ${self.public_ip} ansible_user=admin ansible_ssh_private_key_file=~/.ssh/id_rsa" > ../Ansible/hosts.ini
      ansible-playbook -i ../Ansible/hosts.ini ../Ansible/jenkins_setup.yaml
    EOT
  }
}
