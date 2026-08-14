resource "aws_lb" "backend" {
  name               = "${var.vpc_name}-${var.environment}-backend"
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public.id
  ]

  security_groups = [
    aws_security_group.load_balancer.id
  ]
}

# Ok the LB receives traffic on port 80, but what does it do with it? It needs to forward it to the backend instances, which are in a Target Group.
# Read it almost like English:
# For the backend ALB,
# create an HTTP listener on port 80.
# When traffic arrives, forward it to the backend Target Group.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.backend.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}