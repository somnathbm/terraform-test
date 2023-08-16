# variable "instance_type" {
#   type = string
#   description = "EC2 instance type"
#   default = "t2.micro"
#   validation {
#     condition = can(regex("^t2.", var.instance_type))
#     error_message = "Instance type must be of 2nd generation"
#   }
# }

locals {
  instance_type = ["nano"]
  instance_list = {
    second_gen : {
      generation : "t2",
      capacity : "nano"
    }
  }
}