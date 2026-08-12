variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_name" {
  description = "Base name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "backend_ami_id" {
  description = "AMI ID used by backend EC2 instances"
  type        = string
}

variable "backend_instance_type" {
  description = "EC2 instance type for backend instances"
  type        = string
  default     = "t3.micro"
}