#!/bin/bash

# URL de Jenkins
JENKINS_URL="http://localhost:8080"

# Usuario admin
USERNAME="admin"

# Obtiene la contraseña inicial
PASSWORD=$(cat /var/jenkins_home/secrets/initialAdminPassword)

# Obtiene el crumb para la protección CSRF
CRUMB=$(curl -s -u $USERNAME:$PASSWORD "$JENKINS_URL/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

# Extrae el nombre del campo y el valor del crumb
CRUMB_FIELD=$(echo $CRUMB | cut -d":" -f1)
CRUMB_VALUE=$(echo $CRUMB | cut -d":" -f2)

# Realiza la solicitud POST para desbloquear Jenkins
curl -X POST "$JENKINS_URL/j_spring_security_check" \
  -u $USERNAME:$PASSWORD \
  -H "$CRUMB_FIELD:$CRUMB_VALUE" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "j_username=$USERNAME" \
  --data-urlencode "j_password=$PASSWORD" \
  --data-urlencode "from=%2F" \
  --data-urlencode "$CRUMB_FIELD=$CRUMB_VALUE"

echo "Jenkins unlocked successfully!"
