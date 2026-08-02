resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name        = "${var.vpc_name}-${var.environment}-nat-gateway"
    Environment = var.environment
    Project     = "Forge"
  }
}