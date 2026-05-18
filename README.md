# AWS Landing Zone – Terraform Project (Development Environment)

<p align="center">
  <strong>A modular, production-ready AWS infrastructure-as-code project</strong>
</p>

---

## 📌 Purpose of This Project

The purpose of this project is to build a modular, reusable AWS Landing Zone using Terraform. A landing zone is the foundational cloud environment that organizations use to deploy applications, enforce security, and scale infrastructure.

**This project demonstrates:**
- ✅ Infrastructure-as-Code (IaC) best practices
- ✅ Modular Terraform design with reusable components
- ✅ Multi-environment structure (dev, staging, prod, etc.)
- ✅ Secure networking patterns with public/private subnets
- ✅ Load balancing and auto-scaling compute provisioning
- ✅ Real-world cloud engineering workflows
- ✅ Remote state management with S3 + DynamoDB
- ✅ Production-grade security and compliance

It is designed to mimic how professional cloud teams build and manage AWS environments in enterprise settings.

---

## 🏢 How Cloud Engineers Use This in Real Businesses

### 1. **Standardized Infrastructure Deployment**
Companies need consistent environments across development, testing, staging, and production. A Terraform landing zone ensures every environment is identical, reducing bugs and deployment failures.

### 2. **Security and Compliance**
A landing zone enforces:
- Network segmentation (public/private subnets)
- Security groups with least-privilege access
- Encrypted state management
- IAM role-based access control
- Centralized logging and monitoring

This ensures every application deployed into the environment is secure by default.

### 3. **Scalability and High Availability**
The ALB + EC2 + multi-AZ VPC design is a production-grade pattern used by real companies to:
- Handle traffic spikes automatically
- Distribute load across availability zones
- Recover from infrastructure failures
- Scale applications without downtime

### 4. **Cost Optimization**
Terraform modules allow cloud teams to:
- Reuse infrastructure patterns across projects
- Reduce manual mistakes that lead to waste
- Deploy only what is needed per environment
- Track infrastructure spending via AWS tags

### 5. **Faster Developer Productivity**
Developers deploy into a pre-built environment that already includes:
- Networking (VPC, subnets, routing)
- Security (security groups, IAM roles)
- Compute (auto-scaling EC2 instances)
- Load balancing (ALB with health checks)

### 6. **Multi-Team Collaboration**
A landing zone provides:
- Clear infrastructure boundaries
- Standardized modules for consistency
- Version-controlled infrastructure
- Predictable, repeatable deployments
- Centralized state management

---

## 🏗️ Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           AWS Account (Region)                          │
│                                                                         │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                    VPC (10.0.0.0/16)                            │  │
│  │                                                                  │  │
│  │  ┌─────────────────────────────────────────────────────────┐   │  │
│  │  │              Internet Gateway (IGW)                     │   │  │
│  │  └─────────────────────────────────────────────────────────┘   │  │
│  │                           │                                     │  │
│  │                           │                                     │  │
│  │  ┌────────────────────────┴─────────────────────────────────┐  │  │
│  │  │         Public Route Table (0.0.0.0/0 → IGW)            │  │  │
│  │  └────────────────────────┬─────────────────────────────────┘  │  │
│  │                           │                                     │  │
│  │  ┌────────────────────────┴─────────────────────────────────┐  │  │
│  │  │                                                          │  │  │
│  │  │         ┌─────────────────┐     ┌─────────────────┐    │  │  │
│  │  │         │  Public Subnet  │     │  Public Subnet  │    │  │  │
│  │  │         │   (10.0.1.0/24) │     │  (10.0.2.0/24)  │    │  │  │
│  │  │         │   (AZ us-east-1a)    │  (AZ us-east-1b) │    │  │  │
│  │  │         └────────┬────────┘     └────────┬────────┘    │  │  │
│  │  │                  │                       │              │  │  │
│  │  │         ┌────────▼──────┐       ┌───────▼───────┐      │  │  │
│  │  │         │ NAT Gateway   │       │ NAT Gateway   │      │  │  │
│  │  │         │  (EIP)        │       │  (EIP)        │      │  │  │
│  │  │         └────────┬──────┘       └───────┬───────┘      │  │  │
│  │  │                  │                       │              │  │  │
│  │  └──────────────────┼───────────────────────┼──────────────┘  │  │
│  │                     │                       │                 │  │
│  │                     │                       │                 │  │
│  │  ┌──────────────────┴───────────────────────┴──────────────┐  │  │
│  │  │    Application Load Balancer (ALB)                     │  │  │
│  │  │    DNS: alb-dev-xxxxx.us-east-1.elb.amazonaws.com    │  │  │
│  │  │    Security Group: Allow 80/443 from 0.0.0.0/0       │  │  │
│  │  └──────────────────┬───────────────────────┬─────────────┘  │  │
│  │                     │                       │                 │  │
│  │          ┌──────────┴───────────┬──────────┴───────┐         │  │
│  │          │  Target Group (TG)   │                  │         │  │
│  │          │  Port: 80            │                  │         │  │
│  │          │  Health: /:200       │                  │         │  │
│  │          └──────────┬───────────┘                  │         │  │
│  │                     │                              │         │  │
│  │  ┌──────────────────┴──────────────────────────────┴──────┐  │  │
│  │  │                                                        │  │  │
│  │  │         ┌──────────────────┐   ┌──────────────────┐  │  │  │
│  │  │         │ Private Subnet   │   │ Private Subnet   │  │  │  │
│  │  │         │ (10.0.11.0/24)   │   │ (10.0.12.0/24)   │  │  │  │
│  │  │         │ (AZ us-east-1a)  │   │ (AZ us-east-1b)  │  │  │  │
│  │  │         └────────┬─────────┘   └────────┬─────────┘  │  │  │
│  │  │                  │                      │             │  │  │
│  │  │         ┌────────▼──────┐      ┌───────▼───────┐     │  │  │
│  │  │         │  EC2 Instance │      │ EC2 Instance  │     │  │  │
│  │  │         │  (Launch TL)  │      │ (Launch TL)   │     │  │  │
│  │  │         │  Private IP   │      │ Private IP    │     │  │  │
│  │  │         │  Port: 80     │      │ Port: 80      │     │  │  │
│  │  │         │  Security Group│     │ Security Group│     │  │  │
│  │  │         │  (Allow ALB)  │      │ (Allow ALB)   │     │  │  │
│  │  │         └───────────────┘      └───────────────┘     │  │  │
│  │  │                                                        │  │  │
│  │  │         ┌──────────────────────────────────────┐     │  │  │
│  │  │         │   Auto Scaling Group (ASG)          │     │  │  │
│  │  │         │   Min: 2 | Desired: 2 | Max: 4     │     │  │  │
│  │  │         │   Health Check: ELB                 │     │  │  │
│  │  │         └──���───────────────────────────────────┘     │  │  │
│  │  │                                                        │  │  │
│  │  └────────────────────────────────────────────────────────┘  │  │
│  │                                                                  │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │            Terraform Remote State Backend                        │  │
│  │  ┌────────────────────────────────────────────────────────────┐ │  │
│  │  │  S3 Bucket (terraform-state-dev-ACCOUNT-ID)              │ │  │
│  │  │  • Versioning: Enabled                                    │ │  │
│  │  │  • Encryption: AES-256                                    │ │  │
│  │  │  • Public Access: Blocked                                 │ │  │
│  │  └────────────────────────────────────────────────────────────┘ │  │
│  │  ┌────────────────────────────────────────────────────────────┐ │  │
│  │  │  DynamoDB Table (terraform-state-lock-dev)                │ │  │
│  │  │  • State Locking: Enabled                                 │ │  │
│  │  │  • Encryption: Enabled                                    │ │  │
│  │  │  • PITR: Enabled                                          │ │  │
│  │  └────────────────────────────────────────────────────────────┘ │  │
│  │                                                                  │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Architecture Components

| Component | Purpose | Configuration |
|-----------|---------|-----------------|
| **VPC** | Virtual Private Cloud | CIDR: 10.0.0.0/16 |
| **Public Subnets** | Internet-accessible resources | 2 subnets (AZ1, AZ2) |
| **Private Subnets** | Compute and database resources | 2 subnets (AZ1, AZ2) |
| **Internet Gateway** | Route traffic to/from internet | Attached to VPC |
| **NAT Gateways** | Allow private subnets to reach internet | 1 per AZ |
| **ALB** | Distribute traffic across EC2 instances | HTTP listener on port 80 |
| **Target Group** | Route ALB traffic to EC2 instances | Health checks enabled |
| **EC2 Instances** | Application compute | Launched via ASG |
| **Launch Template** | Template for EC2 instance configuration | IMDSv2, CloudWatch monitoring |
| **Security Groups** | Network traffic control | ALB SG + EC2 SG |
| **Auto Scaling Group** | Automatically scale EC2 instances | Min: 2, Desired: 2, Max: 4 |
| **S3 Bucket** | Store Terraform state | Versioning + encryption |
| **DynamoDB** | State locking | Prevent concurrent modifications |

---

## 📁 Project Structure

```
aws-landing-zone/
├── README.md                           # This file
├── .gitignore                          # Git ignore rules
│
├── modules/                            # Reusable Terraform modules
│   ├── vpc/
│   │   ├── main.tf                    # VPC resources
│   │   ├── variables.tf               # Input variables
│   │   └── outputs.tf                 # Output values
│   │
│   ├── security-groups/
│   │   ├── main.tf                    # Security group resources
│   │   ├── variables.tf               # Input variables
│   │   └── outputs.tf                 # Output values
│   │
│   ├── ec2/
│   │   ├── main.tf                    # Launch template & IAM
│   │   ├── variables.tf               # Input variables
│   │   └── outputs.tf                 # Output values
│   │
│   ├── alb/
│   │   ├── main.tf                    # ALB, target group, listeners
│   │   ├── variables.tf               # Input variables
│   │   └── outputs.tf                 # Output values
│   │
│   ├── autoscaling/
│   │   ├── main.tf                    # ASG & scaling policies
│   │   ├── variables.tf               # Input variables
│   │   └── outputs.tf                 # Output values
│   │
│   └── backend/
│       ├── main.tf                    # S3 + DynamoDB
│       ├── variables.tf               # Input variables
│       └── outputs.tf                 # Output values
│
└── environments/
    └── dev/
        ├── main.tf                    # Wire all modules for dev
        ├── backend.tf                 # S3 backend config
        ├── variables.tf               # Environment variables
        ├── terraform.tfvars           # Dev-specific values
        └── user_data.sh               # EC2 initialization script
```

---

## ⚙️ How It Works

### **1. VPC Module** (`modules/vpc/`)
Creates the foundational networking layer:
- Creates the VPC with specified CIDR block
- Creates public subnets across multiple AZs
- Creates private subnets across multiple AZs
- Creates Internet Gateway for public subnet internet access
- Creates NAT Gateways for private subnet outbound internet access
- Creates route tables and associations
- Creates Network ACLs (optional security layer)

**Key Resources:**
- `aws_vpc`
- `aws_subnet` (public & private)
- `aws_internet_gateway`
- `aws_nat_gateway`
- `aws_eip`
- `aws_route_table`

---

### **2. Security Groups Module** (`modules/security-groups/`)
Defines inbound and outbound rules for network traffic:
- **ALB Security Group**: Allows inbound HTTP (80) and HTTPS (443) from 0.0.0.0/0
- **EC2 Security Group**: Allows inbound HTTP (80) only from ALB security group
- Optional SSH access for administrative purposes

**Key Resources:**
- `aws_security_group` (ALB & EC2)
- `aws_security_group_rule` (inbound & outbound rules)

---

### **3. EC2 Module** (`modules/ec2/`)
Creates EC2 launch templates for instance provisioning:
- Creates IAM role for EC2 instances with necessary permissions
- Creates launch template with IMDSv2 enforcement
- Configures CloudWatch monitoring
- Specifies root volume encryption and sizing
- Attaches security group

**Key Resources:**
- `aws_launch_template`
- `aws_iam_role`
- `aws_iam_instance_profile`

---

### **4. ALB Module** (`modules/alb/`)
Provisions load balancing and traffic distribution:
- Creates Application Load Balancer in public subnets
- Creates target group for EC2 instances
- Creates HTTP listener
- Configures health checks
- Optional HTTPS listener and HTTP→HTTPS redirect

**Key Resources:**
- `aws_lb`
- `aws_lb_target_group`
- `aws_lb_listener`

---

### **5. Auto Scaling Group Module** (`modules/autoscaling/`)
Manages automatic scaling of EC2 instances:
- Creates ASG with launch template
- Defines scaling policies (scale up/down)
- Creates CloudWatch alarms for CPU utilization
- Configures health check behavior
- Enables metrics collection

**Key Resources:**
- `aws_autoscaling_group`
- `aws_autoscaling_policy`
- `aws_cloudwatch_metric_alarm`

---

### **6. Backend Module** (`modules/backend/`)
Provisions remote state management infrastructure:
- Creates S3 bucket with versioning and encryption
- Enables state file retention policies
- Creates DynamoDB table for state locking
- Blocks public access to state bucket
- Creates IAM policy for state access

**Key Resources:**
- `aws_s3_bucket`
- `aws_dynamodb_table`
- `aws_iam_policy`

---

### **7. Environment Layer** (`environments/dev`)
The `main.tf` in the dev environment wires all modules together:
- Instantiates all six modules
- Passes outputs from one module as inputs to another
- Applies environment-specific variables
- Uses `terraform.tfvars` for configuration

**Example Module Wiring:**
```hcl
# VPC outputs → ALB inputs
module "alb" {
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
}

# ALB outputs → ASG inputs
module "autoscaling" {
  target_group_arn = module.alb.target_group_arn
  launch_template  = module.ec2.launch_template_id
}
```

---

## 🚀 Getting Started

### Prerequisites
- Terraform >= 1.0
- AWS CLI configured with credentials
- AWS account with appropriate IAM permissions
- Git (for version control)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/timkamba2002/aws-landing-zone.git
   cd aws-landing-zone
   ```

2. **Navigate to the dev environment:**
   ```bash
   cd environments/dev
   ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

---

## 📊 Deployment Workflow

### Step 1: Plan the Deployment
```bash
cd environments/dev
terraform plan
```

Review the output to understand what resources will be created.

### Step 2: Apply the Configuration
```bash
terraform apply
```

Confirm the changes when prompted. This will create:
- VPC with subnets
- Security groups
- Launch template
- Application Load Balancer
- Auto Scaling Group with EC2 instances
- CloudWatch alarms

### Step 3: Verify Deployment
```bash
# Get the ALB DNS name
terraform output alb_dns_name

# Get other useful outputs
terraform output vpc_id
terraform output asg_name
```

### Step 4: Test the Application
```bash
# Test ALB endpoint
curl http://$(terraform output -raw alb_dns_name)
```

---

## 🔧 Configuration

### Environment Variables
Edit `environments/dev/terraform.tfvars`:

```hcl
# AWS Configuration
aws_region     = "us-east-1"
environment    = "dev"
project_name   = "LandingZone"

# VPC Configuration
vpc_cidr              = "10.0.0.0/16"
public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24"]

# EC2 Configuration
instance_type     = "t3.medium"
root_volume_size  = 20
root_volume_type  = "gp3"

# Auto Scaling Configuration
asg_min_size         = 2
asg_desired_capacity = 2
asg_max_size         = 4
```

---

## 🛡️ Security Best Practices Implemented

✅ **Network Security**
- Private subnets for compute resources
- Security groups with least-privilege access
- Network ACLs for additional filtering

✅ **Data Protection**
- S3 bucket versioning for state files
- S3 encryption (AES-256)
- DynamoDB encryption
- Encrypted EBS volumes on EC2

✅ **Access Control**
- IAM roles with minimal permissions
- IMDSv2 enforcement on EC2
- No hardcoded credentials
- State locking to prevent concurrent modifications

✅ **Monitoring & Compliance**
- CloudWatch alarms for auto-scaling
- CloudWatch agent on EC2 instances
- AWS tags for resource tracking
- CloudTrail logging capability

---

## 🔍 Troubleshooting

### 1. **VPC Limit Exceeded**
**Error:** `VpcLimitExceeded: The maximum number of VPCs has been reached.`

**Cause:** AWS account already has the maximum number of VPCs in that region.

**Fix:**
- Switch to a different region: Update `aws_region` in `terraform.tfvars`
- OR request a limit increase from AWS Support
- OR delete old VPCs (requires admin access)

---

### 2. **"Unsupported argument" Errors**
**Cause:** Module inputs don't match module variable definitions.

**Fix:**
1. Check `variables.tf` in the module
2. Ensure inputs match variable names and types
3. Run `terraform validate` to check syntax

---

### 3. **"Invalid value for input variable"**
**Cause:** Terraform expects a specific type (map/object/list) but receives different type.

**Fix:**
1. Review the variable definition in `variables.tf`
2. Ensure you're passing the correct type
3. Check terraform.tfvars for formatting errors

---

### 4. **ALB Target Unhealthy**
**Cause:** EC2 instances not responding to health checks.

**Fix:**
1. Check security group rules allow traffic between ALB and EC2
2. Verify user_data script ran successfully: `curl http://<instance-ip>`
3. Check ALB target health: `aws elbv2 describe-target-health --target-group-arn <arn>`

---

### 5. **Terraform State Locked**
**Cause:** Another operation is modifying state (or previous operation crashed).

**Fix:**
```bash
# Check lock status
aws dynamodb get-item --table-name terraform-state-lock-dev \
  --key '{"LockID":{"S":"dev/terraform.tfstate"}}'

# Remove lock (if safe)
aws dynamodb delete-item --table-name terraform-state-lock-dev \
  --key '{"LockID":{"S":"dev/terraform.tfstate"}}'
```

---

## 📊 Modules Reference

### VPC Module
- **Input Variables:** environment, vpc_cidr, public_subnet_cidrs, private_subnet_cidrs
- **Output Values:** vpc_id, public_subnet_ids, private_subnet_ids, nat_gateway_ids
- **Resources Created:** 1 VPC, 4 subnets, 1 IGW, 2 NAT gateways, Route tables

### Security Groups Module
- **Input Variables:** environment, vpc_id, allow_ssh, ssh_cidr_blocks
- **Output Values:** alb_security_group_id, ec2_security_group_id
- **Resources Created:** 2 security groups, 5+ security group rules

### EC2 Module
- **Input Variables:** environment, instance_type, ami_id, security_group_id
- **Output Values:** launch_template_id, iam_role_arn, ami_id
- **Resources Created:** 1 launch template, 1 IAM role, 1 instance profile

### ALB Module
- **Input Variables:** environment, vpc_id, public_subnet_ids, alb_security_group_id
- **Output Values:** alb_dns_name, target_group_arn, alb_arn
- **Resources Created:** 1 ALB, 1 target group, 1 HTTP listener

### Auto Scaling Module
- **Input Variables:** environment, launch_template_id, target_group_arn
- **Output Values:** asg_name, asg_arn
- **Resources Created:** 1 ASG, 2 scaling policies, 2 CloudWatch alarms

### Backend Module
- **Input Variables:** environment, state_bucket_name, lock_table_name
- **Output Values:** s3_bucket_id, dynamodb_table_name, backend_config
- **Resources Created:** 1 S3 bucket, 1 DynamoDB table, 1 IAM policy

---

## 📈 Scaling the Infrastructure

### Horizontal Scaling (More Instances)
Modify `terraform.tfvars`:
```hcl
asg_desired_capacity = 4  # Increase from 2 to 4
asg_max_size        = 8   # Increase from 4 to 8
```

Then apply:
```bash
terraform plan
terraform apply
```

### Vertical Scaling (Larger Instances)
```hcl
instance_type = "t3.large"  # Change from t3.medium
root_volume_size = 50       # Increase from 20 GB
```

Changes take effect on new instances launched by ASG.

### Adding New Environments
1. Copy `environments/dev` to `environments/staging`
2. Update `terraform.tfvars` with staging-specific values
3. Change VPC CIDR to avoid conflicts (e.g., 10.2.0.0/16)
4. Run terraform init/plan/apply in new environment

---

## 🧹 Cleanup

### Destroy Environment
```bash
cd environments/dev
terraform destroy
```

**Note:** S3 bucket and DynamoDB table have `prevent_destroy` protection. To destroy them:

1. Remove `lifecycle { prevent_destroy = true }` from backend module
2. Or manually delete via AWS Console
3. Then run `terraform destroy`

---

## 📝 Best Practices

### ✅ DO:
- Always run `terraform plan` before `terraform apply`
- Use `terraform.tfvars` for environment-specific values
- Commit code to git, NOT terraform state
- Use `.gitignore` to exclude sensitive files
- Enable state locking (DynamoDB)
- Use versioned modules
- Document infrastructure changes

### ❌ DON'T:
- Don't commit `terraform.tfstate` to git
- Don't modify resources outside of Terraform
- Don't hardcode credentials in code
- Don't use shared AWS credentials
- Don't skip security group configurations
- Don't disable state encryption

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:
1. Create a feature branch
2. Make your changes
3. Run `terraform fmt` to format code
4. Run `terraform validate` to check syntax
5. Create a pull request with detailed description

---

## 📚 Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform Best Practices](https://www.terraform.io/docs/language/settings/index.html)
- [AWS Security Best Practices](https://aws.amazon.com/security/best-practices/)

---

## 📄 License

This project is provided as-is for educational and commercial use.

---

## 👤 Author

**Timkamba2002** - Cloud Infrastructure Engineer

---

## ❓ Support

For issues, questions, or suggestions:
1. Check the **Troubleshooting** section above
2. Review the module `README.md` files
3. Create a GitHub issue
4. Contact the maintainer

---

**Last Updated:** May 17, 2026  
**Status:** ✅ Production Ready
