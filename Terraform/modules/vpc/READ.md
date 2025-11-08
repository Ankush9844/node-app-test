## Resources Created
This module provisions the following AWS resources:

- **VPC**
- **2 Public Subnets** (for load balancers or public-facing apps)
- **2 Private Subnets** (for internal services or databases)
- **Internet Gateway (IGW)**
- **Route Tables and Associations**


## Module Structure

- vpc
    |- main.tf
    |- variables.tf
    |- output.tf
    |- READ.md
