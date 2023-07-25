# define data source
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["self"]

    filter {
        name = "description"
        values = "Amazon Linux 2023 AMI*"
    }

    filter {
        name = "architecture"
        values = "x86_64"
    }

    filter {
        name = "virtualization_type"
        values = "hvm"
    }

    filter {
        name = "root-device-type"
        values = "ebs"
    }
}

# define aws instance
resource "aws_instance" "apache_server" {
    # Number of EC2 instance to be created
    count = 2

    # Type of EC2 instances
    instance_type = var.instance_type

    # AMI image to use
    ami = data.aws_ami.amazon_linux.id

    # security groups
}