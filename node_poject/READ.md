# Dockerized Node.js Application

This project demonstrates how to containerize a simple **Node.js Express application** using **Docker** best practices, including multi-stage builds, a non-root user, and an optimized lightweight image.

---

## Project Structure

.
├── app.js
├── package.json
├── package-lock.json
├── Dockerfile
├── .dockerignore
└── README.md

## Build and Run Locally

### Build the Image

```bash
docker build -t node-app-test:latest .
```

### Run the Container

```bash
docker run -d -p 3000:3000 node-app-test:latest
```

### Push the Docker image to AWS ECR private repository

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 600748199510.dkr.ecr.us-east-1.amazonaws.com

docker build -t base/node .

docker tag node-app-test:latest 600748199510.dkr.ecr.us-east-1.amazonaws.com/base/node:node-app-test

docker push 600748199510.dkr.ecr.us-east-1.amazonaws.com/base/node:node-app-test
```