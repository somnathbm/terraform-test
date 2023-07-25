variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "sec_ebs_size" {
  type = number
  description = "Secondary EBS volume size"
  default = 8
}