# Terraform AWS Infrastructure

This project provisions a complete AWS infrastructure using **Terraform** in a modular structure.  
It includes networking, compute, security, and CI/CD pipeline components.

---

## Project Structure

Terraform/
├── modules/
│   ├── alb/                  # Application Load Balancer configuration
│   ├── ecs-fargate/          # ECS Fargate cluster and services
│   ├── pipeline/             # CI/CD pipeline setup
│   │ ├── codebuild/          # AWS CodeBuild configuration
│   │ └── codepipeline/       # AWS CodePipeline configuration
│   ├── security-groups/      # Security group definitions
│   └── vpc/                  # VPC with public/private subnets and related resources
│
└── project/
    ├── main.tf               # Main entry point calling modules
    ├── provider.tf           # AWS provider configuration
    ├── variables.tf          # Input variables
    ├── terraform.tfvars      # Variable values
    ├── output.tf             # Output values
    └── terraform.tfstate     # Terraform state file



## How to Use


```bash
# Initialize Terraform
terraform init

# Validate Configuration
terraform validate

# Plan Infrastructure
terraform plan

# Apply Changes
terraform apply

# Destroy Resources
terraform destroy
```

## Modules Overview

1. VPC Module: Creates VPC, 2 public & 2 private subnets, route tables, and gateways.

2. Security Groups Module: Defines SGs for ALB and ECS Fargate.

3. ALB Module: Configures an Application Load Balancer and target groups.

4. ECS Fargate Module: Provisions ECS cluster and services.

5. Pipeline Module: Automates build and deployment using CodeBuild and CodePipeline.


## Notes

- Ensure AWS credentials are configured before running Terraform.
- Customize terraform.tfvars with your environment-specific values.