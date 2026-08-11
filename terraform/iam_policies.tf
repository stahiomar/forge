##############################################################
# IAM POLICY DOCUMENTS
#
# IMPORTANT:
# aws_iam_policy_document DOES NOT create anything in AWS.
#
# It is only a Terraform helper that generates the JSON
# required by IAM resources.
##############################################################

data "aws_iam_policy_document" "ecr" {

  statement {

    effect = "Allow"

    # Placeholder.
    # Later this will become real AWS IAM actions.
    actions = [
      "Read from ecr"
    ]

    # Placeholder.
    # Later this will reference our ECR Repository ARN.
    resources = [
      "Forge Backend Repository"
    ]
  }
}

##############################################################
# Trust Policy
#
# This policy DOES NOT define permissions.
#
# It answers a completely different question:
#
# "Who is allowed to use (assume) this role?"
#
# In our case:
#
# EC2 Service
#        │
#        ▼
# Backend Role
#
# Notice there is NO repository here.
# There are NO ECR permissions here.
#
# This policy is ONLY about trust.
##############################################################

data "aws_iam_policy_document" "backend_assume_role" {

  statement {

    effect = "Allow"

    # Placeholder.
    #
    # Later this will become:
    #
    # EC2 Service
    # because we trust the EC2 SERVICE,
    # not individual EC2 instances.
    ##########################################################
    principals {
      "EC2 service"
    }

    # Placeholder.
    actions = [
      "Assume Role"
    ]
  }
}

##############################################################
# IAM POLICY
#
# This resource creates an IAM Policy in AWS.
#
# After Terraform applies,
# AWS now has a policy called:
#
# Forge-dev-ecr-policy
#
# IMPORTANT:
#
# At this point nobody is using it yet.
#
# It is just sitting inside AWS waiting to be attached to a Role.
##############################################################

resource "aws_iam_policy" "ecr" {
  name        = "${var.vpc_name}-${var.environment}-ecr-policy"
  description = "IAM policy for accessing ECR"

  # Generated JSON from the helper above.
  policy = data.aws_iam_policy_document.ecr.json
}

##############################################################
# IAM ROLE
#
# A Role answers:
#
# "Who should receive these permissions?"
#
# Our Backend EC2 instances will eventually use
# this role.
#
# IMPORTANT:
#
# The role DOES NOT automatically receive the ECR policy.
#
# Terraform will need another resource later that
# explicitly attaches:
#
# ECR Policy
#      │
#      ▼
# Backend Role
##############################################################

resource "aws_iam_role" "backend" {
  name = "${var.vpc_name}-${var.environment}-backend-role"

  # This tells AWS: "The EC2 Service is allowed to assume this role."
  #
  # This does NOT give ECR permissions.
  #
  # It ONLY defines who is allowed to use the role.
  ############################################################
  assume_role_policy = data.aws_iam_policy_document.backend_assume_role.json
}

# Attachment of the ECR policy to the Backend role.
resource "aws_iam_role_policy_attachment" "backend_ecr" {
  role = aws_iam_role.backend.name
  policy_arn = aws_iam_policy.ecr.arn
}