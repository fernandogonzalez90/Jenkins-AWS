#!/bin/bash

# URL de Jenkins
JENKINS_URL="http://localhost:8080"

# Usuario admin
USERNAME="admin"

# Obtiene la contraseña inicial
PASSWORD=$(cat /var/jenkins_home/secrets/initialAdminPassword)

# Obtiene el crumb para la protección CSRF
CRUMB=$(curl -u $USERNAME:$PASSWORD "$JENKINS_URL/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

# Extrae el nombre del campo y el valor del crumb
CRUMB_FIELD=$(echo $CRUMB | cut -d":" -f1)
CRUMB_VALUE=$(echo $CRUMB | cut -d":" -f2)

# Realiza la solicitud POST para desbloquear Jenkins
curl -X POST "$JENKINS_URL/jnlp/console" \
  -u $USERNAME:$PASSWORD \
  -H "$CRUMB_FIELD:$CRUMB_VALUE" \
  -H "Content-Type: application/x-www-form-urlencoded"
