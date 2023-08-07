output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_1a_id" {
  value = aws_subnet.public_1a.id
}

output "public_subnet_1c_id" {
  value = aws_subnet.public_1c.id
}

output "private_subnet_1a_id" {
  value = aws_subnet.private_1a.id
}

output "private_subnet_1c_id" {
  value = aws_subnet.private_1c.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "iam_role_codebuild_arn" {
  value = aws_iam_role.codebuild.arn
}

output "iam_role_codedeploy_arn" {
  value = aws_iam_role.codedeploy_role.arn
}

output "iam_role_codepipeline_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "iam_role_codepipeline_id" {
  value = aws_iam_role.codepipeline_role.id
}

output "s3_codepipeline_bucket" {
  value = aws_s3_bucket.codepipeline_artifact.bucket
}

output "s3_codepipeline_arn" {
  value = aws_s3_bucket.codepipeline_artifact.arn
}
