# get the public DNS
output "apache-alb-dns" {
  value = aws_lb.web.dns_name
  description = "The DNS of the ALB"
}