# Something like Docker Hub, but for AWS. This is where we will store our Docker images for the backend
resource "aws_ecr_repository" "backend" {
  name = "${var.vpc_name}-${var.environment}-backend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.vpc_name}-${var.environment}-backend"
    Environment = var.environment
    Project     = "Forge"
  }
}