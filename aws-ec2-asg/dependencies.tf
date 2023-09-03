# fetch default VPC
data "aws_vpc" "default" {
  default = true
}

# fetch security groups
data "aws_security_groups" "apache" {
  tags = {
    Name = "apache_sg"
  }
}

# fetch subnets
data "aws_subnets" "default" {
  tags = {
    Name = "us_east_1"
  }
}