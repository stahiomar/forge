resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  # This setting ensures that instances launched in this subnet will receive a public IP address
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.vpc_name}-${var.environment}-public-subnet"
    Environment = var.environment
    Project     = "Forge"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.vpc_name}-${var.environment}-private-subnet"
    Environment = var.environment
    Project     = "Forge"
  }
}