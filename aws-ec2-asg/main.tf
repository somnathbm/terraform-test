# create a placement group
resource "aws_placement_group" "apache-pg" {
  name = "apache-pg"
  strategy = "cluster"
}

# create an ALB
resource "aws_lb" "apache-alb" {
  name = "apache-alb"
  load_balancer_type = "application"
  internal = false
  security_groups = data.aws_security_groups.apache-sg.ids
  subnets = data.aws_subnets.apache.ids
}

# define ALB listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.apache-alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: Page not found"
      status_code = 404
    }
  }
}

# define ALB listener rule
resource "aws_lb_listener_rule" "rule" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.apache-tg.arn
  }
}

# define target group
resource "aws_lb_target_group" "apache-tg" {
  name = "apache-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

# create an autoscaling group
resource "aws_autoscaling_group" "apache-asg" {
  name = "apache-asg"
  max_size = 3
  min_size = 2
  desired_capacity = 2
  health_check_type = "ELB"
  force_delete = true
  placement_group = aws_placement_group.apache-pg.id
  target_group_arns = [aws_lb_target_group.apache-tg.arn]

  launch_template {
    name = "Apache"
  }

  availability_zones = ["us-east-1a", "us-east-1e"]

  tag {
    key = "Name"
    value = "apache-sg-server"
    propagate_at_launch = true
  }
}