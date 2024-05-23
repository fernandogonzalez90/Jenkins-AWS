provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  key_name      = "jenkins_key"

  security_groups = [aws_security_group.jenkins_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              # Actualiza la lista de paquetes
              sudo apt-get update

              # Instala paquetes necesarios
              sudo apt-get install -y ca-certificates curl

              # Crea el directorio para las claves GPG de Docker
              sudo install -y -m 0755 -d /etc/apt/keyrings

              # Descarga la clave GPG oficial de Docker
              sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
              sudo chmod a+r /etc/apt/keyrings/docker.asc

              # Añade el repositorio de Docker a las fuentes de Apt
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

              # Actualiza la lista de paquetes nuevamente
              sudo apt-get update

              # Instala Docker
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

              # Ejecuta el contenedor de Jenkins
              sudo docker run -d -p 8080:8080 -p 50000:50000 --name jenkins jenkins/jenkins:lts
              EOF

  tags = {
    Name = "JenkinsServer"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name_prefix = "jenkins-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "jenkins_key"
  public_key = file("clave.pub")
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins_server.public_ip}:8080"
}