# The Launch Template is the recipe for what an EC2 instance should look like.
resource "aws_launch_template" "backend" {
  name = "${var.vpc_name}-${var.environment}-backend"

  # What OS/image does the instance start from?
  image_id = var.backend_ami_id

  # What type of EC2 instance to use (Hardware resources like CPU, RAM, etc.)
  instance_type = var.backend_instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.backend.name
  }

  network_interfaces {
    security_groups = [
      aws_security_group.backend.id
    ]
  }
}