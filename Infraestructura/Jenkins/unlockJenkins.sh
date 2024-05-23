#!/bin/bash

# Replace with the actual Jenkins URL
JENKINS_URL="http://localhost:8080"

# Replace with the actual username and password
USERNAME="admin"
PASSWORD="temporary_password"

# Use curl to perform an authenticated POST request to the unlock endpoint
curl -X POST "$JENKINS_URL/jnlp/console" \
  -d "username=$USERNAME" \
  -d "password=$PASSWORD" \
  -H "Content-Type: application/x-www-form-urlencoded"

echo "Jenkins unlocked successfully!"
