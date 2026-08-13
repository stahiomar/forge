resource "aws_lb_target_group" "backend" {
  name = "${var.vpc_name}-${var.environment}-backend"

  port     = 8000
  protocol = "HTTP"

  vpc_id = aws_vpc.main.id

  health_check {
    protocol = "HTTP"
    path     = "/health"
  }
}