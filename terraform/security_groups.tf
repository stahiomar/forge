resource "aws_security_group" "load_balancer" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.vpc_name}-${var.environment}-load-balancer-sg"
  description = "Security group for the load balancer"
  tags = {
    Name        = "${var.vpc_name}-${var.environment}-load-balancer-sg"
    Environment = var.environment
    Project     = "Forge"
  }
}

resource "aws_security_group" "backend" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.vpc_name}-${var.environment}-backend-sg"
  description = "Security group for the backend"
  tags = {
    Name        = "${var.vpc_name}-${var.environment}-backend-sg"
    Environment = var.environment
    Project     = "Forge"
  }
}

resource "aws_vpc_security_group_ingress_rule" "https" {

  security_group_id = aws_security_group.load_balancer.id

  from_port = 443

  to_port = 443

  ip_protocol = "tcp"

  # That one means who initiates the connection
  cidr_ipv4 = "0.0.0.0/0"

}

resource "aws_vpc_security_group_ingress_rule" "backend_from_lb" {

  security_group_id = aws_security_group.backend.id

  from_port = 8000

  to_port   = 8000

  ip_protocol = "tcp"
  
  # That one means who initiates the connection, in this case the load balancer
  referenced_security_group_id = aws_security_group.load_balancer.id
}