# Security Groups
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

resource "aws_security_group" "postgres" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.vpc_name}-${var.environment}-postgres-sg"
  description = "Security group for the PostgreSQL database"
  tags = {
    Name        = "${var.vpc_name}-${var.environment}-postgres-sg"
    Environment = var.environment
    Project     = "Forge"
  }
}

resource "aws_security_group" "redis" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.vpc_name}-${var.environment}-redis-sg"
  description = "Security group for the Redis cache"
  tags = {
    Name        = "${var.vpc_name}-${var.environment}-redis-sg"
    Environment = var.environment
    Project     = "Forge"
  }
}

# Ingress rules
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

resource "aws_vpc_security_group_ingress_rule" "redis_from_backend" {

  security_group_id = aws_security_group.redis.id

  from_port = 6379

  to_port   = 6379

  ip_protocol = "tcp"
  
  # That one means who initiates the connection, in this case the backend
  referenced_security_group_id = aws_security_group.backend.id
}

resource "aws_vpc_security_group_ingress_rule" "postgres_from_backend" {

  security_group_id = aws_security_group.postgres.id

  from_port = 5432

  to_port   = 5432

  ip_protocol = "tcp"
  
  # That one means who initiates the connection, in this case the backend
  referenced_security_group_id = aws_security_group.backend.id
}