resource "aws_s3_bucket" "count-test" {
  count  = var.count_of_resource
  bucket = "${var.env}-${var.project_name}-count-test"
}
