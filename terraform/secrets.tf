resource "aws_secretsmanager_secret" "backend" {
  name        = "${var.vpc_name}/${var.environment}/backend"
  description = "Secrets used by the Forge backend"

  tags = {
    Name        = "${var.vpc_name}-${var.environment}-backend-secret"
    Environment = var.environment
    Project     = "Forge"
  }
}