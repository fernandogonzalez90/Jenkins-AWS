# Jenkins en AWS usando Terraform y Ansible
Este proyecto despliega Jenkins en AWS usando distintos metodos, hasta el momento se crea la infraestructura con Terraform y se configura esa VPS con Ansible para instalar todo lo necesario para correr Jenkins

### El proyecto se divide en dos carpetas dentro de Infraestructura:
#### Terraform:
Se encarga de crear la infraestructura necesaria en AWS.
- main.tf:

*Contiene el Provider*
- ec2.tf:

*Contine el resource para ec2 y un script para generar autimaticamente el hosts.ini de Ansible y ejecturalo junto con el Playbook*

- par_claves.tf

*Crea un par de claves para conectar Ansible por SSH*

- sg_jenkins.tf

*Crea un grupo de seguridad para el servidor de Jenkins*

- output.tf

*Devuelve la IP publica con el puerto asignado*


#### Ansible:
Esta carpeta contiene dos archivos:
- hosts.ini

*Este archivo se genera automaticamente con el script dentro de ec2.tf y contiene ip publica y usario de SSH*

- jenkins_setup.yaml

*Es el playbook en el cual estan detallados los TASK para añadir claves GPG, repositorios e instalar los programas necesarios*

<b>Una vez ejecutado todo esto hay que recuperar la clave de Jenkins que se encuentra en :
"/var/jenkins_home/secrets/initialAdminPassword"
Esto lo hacemos ingresando a la maquina de EC2 por SSH:</b>

`ssh usuario@ippublica`

Estando dentro del contendor ejecutamos un cat a la ruta que nos dice Jenkins:

`cat /var/jenkins_home/secrets/initialAdminPassword`

Esto nos dara la clave, copiamos y pegamos en la web de Jenkins.
