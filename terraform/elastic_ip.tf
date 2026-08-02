resource "aws_eip" "nat" {
  tags = {
    Name        = "${var.vpc_name}-${var.environment}-nat-eip"
    Environment = var.environment
    Project     = "Forge"
  }
}