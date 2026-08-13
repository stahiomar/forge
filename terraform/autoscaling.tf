# Autoscaling group for backend instances to set how much instances we want to run and where
# And what is the recipe to launch the instances with
resource "aws_autoscaling_group" "backend" {

  name = "${var.vpc_name}-${var.environment}-backend"

  min_size = 2

  max_size = 10

  desired_capacity = 2

  vpc_zone_identifier = [
    aws_subnet.private.id
  ]

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  # Automatically register the instances created by this ASG
  # in the backend Target Group.
  target_group_arns = [
    aws_lb_target_group.backend.arn
  ]
}