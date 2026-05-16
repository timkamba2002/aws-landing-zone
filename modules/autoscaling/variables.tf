variable "name" {
  description = "Name prefix for Auto Scaling resources"
  type        = string
}

variable "launch_template_id" {
  description = "ID of the EC2 launch template"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ASG"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 2
}
