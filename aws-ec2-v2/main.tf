# refer the launch template
data "aws_launch_template" "apache_lt" {
  name = "Apache"
}

# refer to the vpc
data "aws_vpc" "default" {
  default = true
  id = "vpc-0f52f00b83514b404"
}

# refer to the subnets
data "aws_subnets" "us_east_1" {
  filter {
    name = "tag:Name"
    values = ["us_east_1"]
  }
}

# create security groups
resource "aws_security_group" "apache_sg1" {
  name = "apache_sg1"
  description = "Security group for Apache launch template"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "apache_sg1"
  }
}

# provision EC2
resource "aws_instance" "apache_server" {
  # launch template to create instance
  launch_template {
    name = "Apache"
  }

  # instance type
  instance_type = var.instance_type

  # vpc security group ids
  vpc_security_group_ids = [aws_security_group.apache_sg1.id]
  
  # iterate through subnets
  for_each = toset(data.aws_subnets.us_east_1.ids)
  subnet_id = each.key

  # tags
  tags = {
    Name = "apache-${regex("0\\w{3}", each.key)}"
  }
}