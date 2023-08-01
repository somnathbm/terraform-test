variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
  validation {
    condition = can(regex("^t2\\.", var.instance_type))
    error_message = "The instance must be of t2 generation"
  }
}

variable "sec_ebs_size" {
  type = number
  description = "Secondary EBS volume size"
  default = 8
}