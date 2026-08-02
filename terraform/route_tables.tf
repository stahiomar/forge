resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.vpc_name}-${var.environment}-public-rt"
    Environment = var.environment
    Project     = "Forge"
  }
}

resource "aws_route" "internet" {
  route_table_id = aws_route_table.public.id

  destination_cidr_block = "0.0.0.0/0"

  #Which gateway should traffic go to?
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}








resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.vpc_name}-${var.environment}-private-rt"
    Environment = var.environment
    Project     = "Forge"
  }
}

resource "aws_route" "nat" {
  route_table_id = aws_route_table.private.id

  destination_cidr_block = "0.0.0.0/0"

  #Which gateway should traffic go to?
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}