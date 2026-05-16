variable "vpc_id" {
  description = "The ID of the VPC where security groups will be created"
  type        = string
}

variable "name" {
  description = "Name prefix for all security groups"
  type        = string
}
