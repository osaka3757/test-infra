# ------------------------------------------------------------#
#  IAM codebuild
# ------------------------------------------------------------#

data "aws_iam_policy_document" "codebuild_assume_role" {
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
  name               = "${var.project_prefix}-codebuild-assume-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
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

# ------------------------------------------------------------#
#  IAM codedeploy
# ------------------------------------------------------------#

resource "aws_iam_role" "codedeploy_role" {
  name               = "${var.project_prefix}-codedeploy-assume-role"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_policy_document.json
}

data "aws_iam_policy_document" "codedeploy_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.codedeploy_role.id
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# ------------------------------------------------------------#
#  IAM codepipeline
# ------------------------------------------------------------#

data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.project_prefix}-codepipeline-assume-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}
