resource "aws_s3_bucket" "codepipeline_artifact" {
  bucket = "${var.project_prefix}-codepipeline-artifact"
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "codepipeline_bucket_lifecycle" {
  bucket = aws_s3_bucket.codepipeline_artifact.id

  rule {
    id     = "delete_1day"
    status = "Enabled"

    expiration {
      days = 1
    }
  }

}
