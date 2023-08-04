resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.customer_prefix}-codepipeline-bucket"
}

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

# resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
#   bucket = aws_s3_bucket.codepipeline_bucket.id
#   acl    = "private"
# }
