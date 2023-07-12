# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-client-${var.env}-public-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-client-${var.env}-private-route-table"
  }
}


# https://www.terraform.io/docs/providers/aws/r/route.html
# https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/main.tf#L1011
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id

  timeouts {
    create = "5m"
  }
}

# resource "aws_route" "private" {
#   destination_cidr_block = "0.0.0.0/0"
#   route_table_id         = aws_route_table.private.id

#   timeouts {
#     create = "5m"
#   }
# }
