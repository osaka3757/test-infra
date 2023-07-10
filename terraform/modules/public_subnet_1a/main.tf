# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "public_1a" {

  availability_zone = "ap-northeast-1a"
  cidr_block        = var.cidr_block
  vpc_id            = var.vpc_id

  tags = {
    Name = "${var.prefix}-public-subnet-1a"
  }
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = var.public_rtb_id
}

