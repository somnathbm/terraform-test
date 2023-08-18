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

# create security groups
# resource "aws_security_group" "apache_sg1" {
#   name        = "apache_sg1"
#   description = "Security group for Apache launch template"
#   vpc_id      = data.aws_vpc.default.id

#   # ingress {
#   #   from_port   = 80
#   #   to_port     = 80
#   #   protocol    = "tcp"
#   #   cidr_blocks = ["0.0.0.0/0"]
#   # }

#   # using dynamic blocks
#   dynamic "ingress" {
#     for_each = local.ingress_rules

#     content {
#       from_port = ingress.value.port
#       to_port = ingress.value.port
#       protocol = ingress.value.protocol
#       description = ingress.value.description
#       cidr_blocks = ingress.value.cidr_blocks
#     }
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "apache_sg1"
#   }
# }

# using the AWS security groups module
module "apache_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "5.1.0"

  name = "apache_sg"
  description = "A simple SG to handle HTTP traffic"
  vpc_id = data.aws_vpc.default.id
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

# provision EC2
resource "aws_instance" "my_apache_server" {
  # launch template to create instance
  launch_template {
    name = "Apache"
  }

  # instance type
  # instance_type = var.instance_type
  # for_each = toset([for value in local.instance_type: "t2.${value}"]) # <-- List/tuple of instance types
  # for_each = {for k, v in local.instance_list: k => "${v.generation}.${v.capacity}"} # <-- Map of instance type objects

  // input: map of instance type object. output: map of custom object
  for_each      = { for k, v in local.instance_list : k => { inst : "${v.generation}.${v.capacity}", subn : random_shuffle.subnets.result[0] } }
  instance_type = each.value.inst

  # vpc security group ids
  # vpc_security_group_ids = [aws_security_group.apache_sg1.id]
  vpc_security_group_ids = [module.apache_sg.security_group_id]

  # grab a random subnet
  subnet_id = each.value.subn

  # tags
  tags = {
    # Name = "apache-${regex("0\\w{3}", each.key)}"
    Name = "apache-${each.value.inst}"
  }
}

# status checks
# resource "null_resource" "apache_server_health_checks" {
#   # count = length(toset(data.aws_subnets.us_east_1.ids))
#   for_each = aws_instance.apache_server
#   provisioner "local-exec" {
#     command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.apache_server[each.key].id} --no-verify-ssl"
#   }

#   # depends on instance
#   depends_on = [
#     aws_instance.apache_server
#   ]
# }