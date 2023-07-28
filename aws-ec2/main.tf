# lookup ami data source
data "aws_ami" "amazon_linux" {
  most_recent      = true
  name_regex       = "^al2023-ami-2023*"
  owners           = ["amazon"]

  # filter using name
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  # filter using architecture
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# define vpc data source
data "aws_vpc" "default" {
  default = true
  id      = "vpc-0f52f00b83514b404"
}

# define instance profile data source
data "aws_iam_instance_profile" "ec2_ssm" {
    name = "EC2SSMRole"
}

# define security groups
# TODO - module
# security groups resource
resource "aws_security_group" "tf_server_sg" {
  name        = "tf_server_sg"
  description = "A security group to test out TF"
  vpc_id      = data.aws_vpc.default.id

  # incoming traffic - HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf_server_sg"
  }
}

# define aws instance as resource
# TODO - module
resource "aws_instance" "apache_server" {
  # Number of EC2 instance to be created
  # count = 2

  # Type of EC2 instances
  instance_type = var.instance_type

  # AMI image to use
  ami = data.aws_ami.amazon_linux.id

  # security groups
  vpc_security_group_ids = [aws_security_group.tf_server_sg.id]

  # IAM role
  iam_instance_profile = data.aws_iam_instance_profile.ec2_ssm.role_name

  # user data script
  user_data = file("./userdata.yml")

  # tags
  tags = {
    # Name      = "test-apache-server-${count.index}"
    Name      = "test-apache-server"
    CreatedBy = "dev01"
  }
}