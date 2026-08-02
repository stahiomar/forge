# This resource creates an Elastic IP address for the NAT Gateway. The EIP is associated with the NAT Gateway to allow instances in the private subnet to access the internet.
resource "aws_eip" "nat" {
  tags = {
    Name        = "${var.vpc_name}-${var.environment}-nat-eip"
    Environment = var.environment
    Project     = "Forge"
  }
}