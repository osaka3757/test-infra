resource "aws_ecr_repository" "customer_api" {
  name                 = "${var.customer_prefix}/api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository_policy" "api" {
  repository = aws_ecr_repository.customer_api.name

  policy = data.aws_iam_policy_document.api.json
}

data "aws_iam_policy_document" "api" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}
