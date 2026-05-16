# Name prefix for VPC resources
variable "name" {
  description = "Name prefix for all VPC resources"
  type        = string
}

# VPC CIDR block
variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

# Availability Zones
variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

# Public subnets (map of objects)
variable "public_subnets" {
  description = "Map of public subnets with CIDR and AZ index"
  type = map(object({
    cidr_block = string
    az_index   = number
  }))
}

# Private subnets (map of objects)
variable "private_subnets" {
  description = "Map of private subnets with CIDR and AZ index"
  type = map(object({
    cidr_block = string
    az_index   = number
  }))
}
