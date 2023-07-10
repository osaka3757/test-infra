# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
resource "aws_internet_gateway" "main" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.prefix}-igw"
  }
}
