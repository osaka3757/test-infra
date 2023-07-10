# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "private_1c" {

  availability_zone = "ap-northeast-1c"
  cidr_block        = var.cidr_block
  vpc_id            = var.vpc_id

  tags = {
    Name = "${var.prefix}-private-subnet-1c"
  }
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = var.private_rtb_id
}

