# Content :
# 1. Permission policy documents
# 2. Trust policy document
# 3. IAM policies
# 4. IAM role
# 5. Policy attachments
# 6. Instance profile

##############################################################
# IAM POLICY DOCUMENTS
#
# aws_iam_policy_document does NOT create anything in AWS.
# It generates JSON that will later be used by IAM resources.
##############################################################

##############################################################
# ECR PERMISSION POLICY DOCUMENT
##############################################################

data "aws_iam_policy_document" "ecr" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]

    resources = [
      aws_ecr_repository.backend.arn
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }
}

##############################################################
# SECRETS MANAGER PERMISSION POLICY DOCUMENT
##############################################################

data "aws_iam_policy_document" "secrets" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      aws_secretsmanager_secret.backend.arn
    ]
  }
}

##############################################################
# TRUST POLICY DOCUMENT
#
# This answers:
#
# "WHO is allowed to assume the Backend Role?"
#
# It does NOT define what the role can access.
##############################################################

data "aws_iam_policy_document" "backend_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}


##############################################################
# IAM POLICIES
#
# These create actual IAM policies in AWS.
##############################################################

resource "aws_iam_policy" "ecr" {
  name        = "${var.vpc_name}-${var.environment}-ecr-policy"
  description = "IAM policy for accessing ECR"

  policy = data.aws_iam_policy_document.ecr.json
}

resource "aws_iam_policy" "secrets" {
  name        = "${var.vpc_name}-${var.environment}-secrets-policy"
  description = "IAM policy for accessing the Forge backend secret"

  policy = data.aws_iam_policy_document.secrets.json
}


##############################################################
# IAM ROLE
#
# The Backend Role is the identity used by backend EC2 instances.
#
# The trust policy determines WHO can assume the role.
# Permission policies determine WHAT the role can access.
##############################################################

resource "aws_iam_role" "backend" {
  name = "${var.vpc_name}-${var.environment}-backend-role"

  assume_role_policy = data.aws_iam_policy_document.backend_assume_role.json
}


##############################################################
# POLICY ATTACHMENTS
#
# These explicitly connect policies to the Backend Role.
#
# Backend Role
#     │
#     ├── ECR Policy
#     └── Secrets Policy
##############################################################

resource "aws_iam_role_policy_attachment" "backend_ecr" {
  role       = aws_iam_role.backend.name
  policy_arn = aws_iam_policy.ecr.arn
}

resource "aws_iam_role_policy_attachment" "backend_secrets" {
  role       = aws_iam_role.backend.name
  policy_arn = aws_iam_policy.secrets.arn
}


##############################################################
# INSTANCE PROFILE
#
# EC2 uses an Instance Profile to receive the Backend Role.
#
# Launch Template
#       │
#       ▼
# Instance Profile
#       │
#       ▼
# Backend Role
##############################################################

resource "aws_iam_instance_profile" "backend" {
  name = "${var.vpc_name}-${var.environment}-backend-instance-profile"

  role = aws_iam_role.backend.name
}