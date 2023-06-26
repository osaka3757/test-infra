data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "codebuild-assume-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = ["*"]
  }

  # statement {
  #   effect    = "Allow"
  #   actions   = ["ec2:CreateNetworkInterfacePermission"]
  #   resources = ["arn:aws:ec2:us-east-1:123456789012:network-interface/*"]

  #   condition {
  #     test     = "StringEquals"
  #     variable = "ec2:AuthorizedService"
  #     values   = ["codebuild.amazonaws.com"]
  #   }
  # }

  # TODO リソースやアクションの制約を限定する
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["codebuild:*"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codebuild" {
  role   = aws_iam_role.codebuild.name
  policy = data.aws_iam_policy_document.codebuild.json
}

resource "aws_codebuild_project" "codebuild" {
  name          = "${var.env}-${var.project_name}-codebuild"
  description   = "${var.env}_${var.project_name}_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  # cache {
  #   type     = "S3"
  #   location = var.s3_artifact_name
  # }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "PROJECT_NAME"
      value = var.project_name
    }

    environment_variable {
      name  = "ENV"
      value = var.env
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/code-build/${var.env}/${var.project_name}"
      stream_name = "build"
    }

    # s3_logs {
    #   status   = "ENABLED"
    #   location = "${aws_s3_bucket.example.id}/build-log"
    # }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/osaka3757/cds-customer-frontend.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

}
