resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name        = "${var.vpc_name}-${var.environment}-public-subnet"
    Environment = var.environment
    Project     = "Forge"
  }
}