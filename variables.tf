# variable "instance_type" {
#   type = string
#   description = "EC2 instance type"
#   default = "t2.micro"
#   validation {
#     condition = can(regex("^t2.", var.instance_type))
#     error_message = "Instance type must be of 2nd generation"
#   }
# }

variable "server_type" {
  type = string
  description = "Usage type of the server"
  default = "web-server"  
}

locals {
  instance_type = ["nano"]
  instance_list = {
    second_gen : {
      generation : "t2",
      capacity : "nano"
    }
  }

  # SG ingress settings
  ingress_rules = [
    {
      port: 80,
      protocol: "tcp",
      description: "HTTP port 80",
      cidr_blocks: ["0.0.0.0/0"]
    },
    {
      port: 443,
      protocol: "tcp",
      description: "HTTP port 443",
      cidr_blocks: ["0.0.0.0/0"]
    }
  ]
}