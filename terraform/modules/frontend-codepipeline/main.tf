# ------------------------------------------------------------#
#  CodeStar Connection
# ------------------------------------------------------------#

# NOTICE: Connection 作成後に手動で AWS コンソールから GitHub の認証を行う必要がある
resource "aws_codestarconnections_connection" "github" {
  name          = "${var.env}-${var.project_name}-github-connection"
  provider_type = "GitHub"
}

# ------------------------------------------------------------#
#  CodePipeline
# ------------------------------------------------------------#

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.env}-${var.project_name}-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["Source"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = var.frontend_repository_path
        BranchName           = "main"
        OutputArtifactFormat = "CODE_ZIP"
        DetectChanges        = true
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "${var.env}-${var.project_name}-frontend-build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["Source"]
      version         = "1"
      configuration = {
        ProjectName = var.codebuild_name
      }
    }
  }

}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "test-bucket-codepipeline-osaka"
}

# resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
#   bucket = aws_s3_bucket.codepipeline_bucket.id
#   acl    = "private"
# }

resource "aws_s3_bucket_lifecycle_configuration" "codepipeline_bucket_lifecycle" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  rule {
    id     = "delete_1day"
    status = "Enabled"

    expiration {
      days = 1
    }
  }

}

data "aws_iam_policy_document" "assume_role" {
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
  name               = "test-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.codepipeline_bucket.arn,
      "${aws_s3_bucket.codepipeline_bucket.arn}/*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:UseConnection"]
    resources = [aws_codestarconnections_connection.github.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}
