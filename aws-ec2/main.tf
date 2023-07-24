# define data source
data "aws_ami" "amazon_linux" {
    filter {
        name = "name"
        values = "Amazon Linux 2023 AMI"
    }
    most_recent = true
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