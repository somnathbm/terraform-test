# refer to the vpc
data "aws_vpc" "default" {
  default = true
  id      = "vpc-0f52f00b83514b404"
}

# refer to the subnets
data "aws_subnets" "us_east_1" {
  filter {
    name   = "tag:Name"
    values = ["us_east_1"]
  }
}

# random subnets resourec
resource "random_shuffle" "subnets" {
  input        = data.aws_subnets.us_east_1.ids
  result_count = 1
}

# module - aws security group
module "apache_sg_hhtp_ssh" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name = "apache_sg"
  description = "A simple SG to handle HTTP & SSH connections"
  vpc_id = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["http-80-tcp", "ssh-tcp"]
}