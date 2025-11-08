## Overview
This Terraform module creates **two AWS Security Groups**:
1. **Application Load Balancer (ALB) Security Group**
2. **ECS Fargate Security Group**

It is designed for containerized workloads hosted behind an ALB, following AWS best practices for networking and security.

---

## Resources Created
This module provisions the following AWS resources:

- **ALB Security Group**
  - Allows inbound HTTP (port 80) and HTTPS (port 443)
  - Allows outbound traffic to ECS services
- **ECS Fargate Security Group**
  - Allows inbound traffic **only from ALB SG**
  - Allows outbound access to the internet (for updates, APIs, etc.)

---

## Module Structure

- security-groups
    |- main.tf
    |- variables.tf
    |- output.tf
    |- READ.md