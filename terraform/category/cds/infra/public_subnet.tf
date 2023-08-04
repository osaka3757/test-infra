# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "public_1a" {

  availability_zone = "ap-northeast-1a"
  cidr_block        = var.public_subnet_1a_cidr_block
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "${var.project_prefix}-customer-public-subnet-1a"
  }
}

resource "aws_subnet" "public_1c" {

  availability_zone = "ap-northeast-1c"
  cidr_block        = var.public_subnet_1c_cidr_block
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "${var.project_prefix}-customer-public-subnet-1c"
  }
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}
