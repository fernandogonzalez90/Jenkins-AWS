# Jenkins en AWS usando Terraform y Docker
Pruebas para desplegar Jenkins en EC2 de AWS con Terraform y Docker.

### En esta practica lo que hago es crear un main.tf que contiene:
- provider "aws"
  (que solo contiene la region)
- resource "aws_instance"
  (Este contiene la ami, instance_type, key_name, security_groups, un user_data que ejecuta comandos bash para instalar docker y ejecutar una imagen de Jenkins)
- resource "aws_security_group"
  (Contiene los ingress y egress correspondientes para conectarse por ssh y acceder a jenkins desde todas las IPs)
- resource "aws_key_pair"
  (Este tiene key_name y public_key desde un file)
- output "jenkins_url"
  (al finalizar terraform devuelve la ip publica con el puerto para acceder a Jenkins)

<b>Una vez ejecutado todo esto hay que recuperar la clave de Jenkins que se encuentra en :
"/var/jenkins_home/secrets/initialAdminPassword"
Esto lo hacemos ingresando a la maquina de EC2 por SSH:</b>

`ssh usuario@ippublica`

Una vez dentro debemos ejecutar una terminal interactiva del contenedor Docker y lo hacemos con:

`sudo docker exec -it jenkins /bin/bash`

Estando dentro del contendor ejecutamos un cat a la ruta que nos dice Jenkins:

`cat /var/jenkins_home/secrets/initialAdminPassword`

Esto nos dara la clave, copiamos y pegamos en la web de Jenkins.
