variable "ami_id" {
  description = "AMI ID for EC2 instances in the dev environment"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the dev environment"
  type        = string
  default     = "t2.micro"
}
