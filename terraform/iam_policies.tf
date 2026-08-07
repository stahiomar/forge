data "aws_iam_policy_document" "ecr" {

  statement {

    effect = "Allow"

    actions = [
      "Read from ecr"
    ]

    resources = [
      "Forge Backend Repository"
    ]
  }

}

data "aws_iam_policy_document" "backend_assume_role" {

    statement {

        effect = "Allow"

        principals {
            "EC2 service"
        }

        actions = [
            "Forge Backend Repository"
        ]
    }

}

resource "aws_iam_policy" "ecr" {
  name        = "${var.vpc_name}-${var.environment}-ecr-policy"
  description = "IAM policy for accessing ECR"
  policy      = data.aws_iam_policy_document.ecr.json
}

resource "aws_iam_role" "backend" {
  name               = "${var.vpc_name}-${var.environment}-backend-role"
  assume_role_policy = data.aws_iam_policy_document.backend_assume_role.json
}