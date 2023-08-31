# fetch default VPC
data "aws_vpc" "default" {
  default = true
}

# fetch security groups
data "aws_security_groups" "apache-sg" {
  tags = {
    Name = "apache_sg"
  }
}

# fetch subnets
data "aws_subnets" "apache" {
  tags = {
    Name = "us_east_1"
  }
}