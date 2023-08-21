output "public_ips" {
  # use for-in expression
  value = {
    for k, v in aws_instance.my_apache_server : k => v.public_ip
  }
}