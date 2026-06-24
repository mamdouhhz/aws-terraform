# AWS Multi-AZ VPC Infrastructure with Terraform

A Terraform project that provisions a **multi-tier AWS infrastructure** across **two Availability Zones** using a modular design.
The environment is designed around a **public web tier** and a **private application tier**, with both **external** and **internal** load balancing, private subnet egress through a **NAT Gateway**, and security groups that enforce controlled traffic flow between tiers.

---

## Architecture Overview

This project deploys:

* **Custom VPC**
* **2 public subnets** across two AZs
* **2 private subnets** across two AZs
* **Internet Gateway** for public ingress/egress
* **NAT Gateway + Elastic IP** for outbound internet access from private instances
* **Public route table** for public subnets
* **Private route table** for private subnets
* **External Application Load Balancer**
* **Internal Application Load Balancer**
* **2 web EC2 instances** in the public subnets
* **2 app EC2 instances** in the private subnets
* **Target groups and listener rules**
* **Security groups** that enforce the intended communication path

---

## High-Level Traffic Flow

The infrastructure is designed as a **two-tier application path**:

1. **Internet traffic** reaches the **Internet-facing (External) Load Balancer**
2. The Internet-facing (External) Load Balancer forwards traffic to the **web servers** in the public subnets
3. The web servers act as a reverse-proxy layer and forward requests internally
4. Requests are sent to the **internal load balancer**
5. The internal load balancer distributes traffic to the **application servers** in the private subnets
6. Private instances use the **NAT Gateway** for outbound internet access when needed

### Logical flow

```text
Internet
   ↓
Internet Gateway
   ↓
Internet-facing (External) Load Balancer
   ↓
Web Tier (Public Subnets)
   ↓
Internal Load Balancer
   ↓
Application Tier (Private Subnets)
   ↓
NAT Gateway (for outbound internet access only)
```

---

## Infrastructure Layout

### Networking

* **VPC CIDR:** `10.0.0.0/16`
* **Public subnets:** host the web tier and internet-facing load balancer path
* **Private subnets:** host the application tier with no public IP exposure
* **Public route table:** routes `0.0.0.0/0` to the Internet Gateway
* **Private route table:** routes `0.0.0.0/0` to the NAT Gateway

### Load Balancing

* **External ALB**

  * Internet-facing
  * Receives inbound traffic from users
  * Routes requests to the **web tier**

* **Internal ALB**

  * Private
  * Only reachable from the web tier
  * Routes requests to the **application tier**

### Compute

* **Web tier**

  * 2 EC2 instances across 2 AZs
  * Placed in **public subnets**
  * Intended to receive traffic from the external ALB
  * Can proxy requests to the internal ALB

* **Application tier**

  * 2 EC2 instances across 2 AZs
  * Placed in **private subnets**
  * Intended to receive traffic only from the internal ALB
  * No direct public exposure

---

## Security Model

The security design separates access between the internet-facing tier and the internal application tier.

### Expected access pattern

* **Internet → External ALB**
* **External ALB → Web tier**
* **Web tier → Internal ALB**
* **Internal ALB → App tier**
* **App tier outbound → NAT Gateway**

### Security group intent

This project uses dedicated security groups for:

* the Internet-facing (External) Load Balancer
* the internal load balancer
* the web tier
* the app tier

This allows traffic to be restricted by source, rather than opening tiers broadly.

---

## Project Structure

Example module layout:

```text
.
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── terraform.tfvars
├── modules/
│   ├── vpc/
│   ├── nat/
│   ├── security_groups/
│   ├── alb/
│   └── compute/
└── environments/
    └── dev/
        └── terraform.tfvars
    └── staging/
        └── terraform.tfvars
    └── prod/
        └── terraform.tfvars
```

---

## Modules

## 1) VPC Module

Responsible for:

* VPC creation
* public subnets
* private subnets

## 2) NAT / Routing Module

Responsible for:

* Internet Gateway
* Elastic IP
* NAT Gateway
* public route table + association
* private route table + association

## 3) Security Groups Module

Responsible for:

* external ALB security group
* internal ALB security group
* web tier security group
* app tier security group

## 4) ALB Module

Responsible for:

* Internet-facing (External) Load Balancer
* internal load balancer
* listeners
* target groups
* target group attachments

## 5) Compute Module

Responsible for:

* web EC2 instances
* app EC2 instances

---

## Prerequisites

Before using this project, make sure you have:

* [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
* An AWS account
* AWS credentials configured locally
* A key pair available if your EC2 instances require SSH access

You can verify Terraform with:

```bash
terraform version
```

And verify AWS CLI credentials with:

```bash
aws sts get-caller-identity
```

---

## How to Use

## 1. Clone the repository

```bash
git clone <your-repo-url>
cd aws-multi-az-vpc-terraform
```

## 2. Initialize Terraform

```bash
terraform init
```

## 3. Review the execution plan

If you use a variable file:

```bash
terraform plan -var-file=environments/dev/terraform.tfvars
```

Otherwise:

```bash
terraform plan
```

## 4. Apply the infrastructure

```bash
terraform apply -var-file=environments/dev/terraform.tfvars
```

---

## Validation / Testing Ideas

After deployment, you can validate the environment by checking:

### Networking

* Public instances receive public IPs if intended
* Private instances do not have public IPs
* Public route table points to the Internet Gateway
* Private route table points to the NAT Gateway

### Load balancing

* External ALB is reachable publicly
* External target group shows healthy web instances
* Internal ALB is reachable from the web tier
* Internal target group shows healthy app instances

### Instance access

* SSH to public web instances if configured
* Confirm app instances are only reachable internally

### CloudWatch

You can generate traffic or CPU activity on EC2 instances and verify:

* `CPUUtilization`
* `NetworkIn`
* `NetworkOut`

---

## Common Terraform Commands

### Format code

```bash
terraform fmt -recursive
```

### Validate configuration

```bash
terraform validate
```

### Preview changes

```bash
terraform plan -var-file=environments/dev/terraform.tfvars
```

### Apply changes

```bash
terraform apply -var-file=environments/dev/terraform.tfvars
```

### Destroy infrastructure

```bash
terraform destroy -var-file=environments/dev/terraform.tfvars
```

---

## Notes / Design Decisions

* The architecture is intentionally split into **modules** to keep responsibilities isolated and make the project easier to extend.
* The **web tier** and **application tier** are separated across **public** and **private** subnets.
* The **internal ALB** provides an additional internal routing layer between the web and application tiers.
* The **NAT Gateway** allows private instances to access the internet for updates or package installation without exposing them publicly.

---

## Potential Improvements

Possible next steps for this project:

* Add **Auto Scaling Groups** instead of standalone EC2 instances
* Use **Launch Templates**
* Add **ACM + HTTPS listeners**
* Add **Route 53** records
* Add **CloudWatch alarms**
* Install the **CloudWatch Agent** for memory/disk metrics
* Use **remote Terraform state** with S3 + DynamoDB locking
* Add **CI/CD** for validation and deployment
* Replace hardcoded values with more reusable environment variables and inputs

---

## Cleanup

To destroy all created infrastructure:

```bash
terraform destroy -var-file=environments/dev/terraform.tfvars
```

Be careful with:

* Elastic IPs
* NAT Gateway charges
* manually created AWS resources outside Terraform

---

## Author

Built as a Terraform AWS infrastructure project focused on:

* modular infrastructure design
* VPC and subnet architecture
* route tables and NAT
* multi-tier application deployment
* ALB-based traffic flow
* Terraform module composition
