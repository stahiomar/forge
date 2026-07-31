resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.vpc_name}-${var.environment}-igw"
    Environment = var.environment
    Project     = "Forge"
  }
}