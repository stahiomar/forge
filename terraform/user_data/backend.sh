#!/bin/bash

set -e

# AWS region where the Forge ECR repository exists.
AWS_REGION="${aws_region}"

# Docker image that the backend should run.
BACKEND_IMAGE="${backend_image}"

# Authenticate Docker to Amazon ECR.
aws ecr get-login-password --region "$AWS_REGION" \
  | docker login \
      --username AWS \
      --password-stdin \
      "$(echo "$BACKEND_IMAGE" | cut -d'/' -f1)"

# Pull the exact backend image we want to run.
docker pull "$BACKEND_IMAGE"

# Start the Forge backend container.
docker run -d \
  --name forge-backend \
  --restart unless-stopped \
  -p 8000:8000 \
  "$BACKEND_IMAGE"