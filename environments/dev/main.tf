module "vpc" {
  source = "../../modules/vpc"

  name       = "dev"
  cidr_block = "10.0.0.0/16"

  azs = ["us-east-1a", "us-east-1b"]

  public_subnets = {
    public1 = {
      cidr_block = "10.0.1.0/24"
      az_index   = 0
    }
    public2 = {
      cidr_block = "10.0.2.0/24"
      az_index   = 1
    }
  }

  private_subnets = {
    private1 = {
      cidr_block = "10.0.3.0/24"
      az_index   = 0
    }
    private2 = {
      cidr_block = "10.0.4.0/24"
      az_index   = 1
    }
  }
}

module "security_groups" {
  source = "../../modules/security-groups"

  name   = "dev-security"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source = "../../modules/alb"

  name              = "dev-alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  # This module wants a single security_group_id, not "alb_sg_id"
  security_group_id = module.security_groups.alb_sg_id
}

module "ec2" {
  source = "../../modules/ec2"

  name            = "dev-ec2"
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = module.vpc.private_subnet_ids[0]

  # This module also wants "security_group_id", not "ec2_sg_id"
  security_group_id = module.security_groups.ec2_sg_id
}
