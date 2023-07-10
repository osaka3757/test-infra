# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.prefix}-private-route-table"
  }
}

# https://www.terraform.io/docs/providers/aws/r/route.html
# https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/main.tf#L1011
# resource "aws_route" "private" {
#   destination_cidr_block = "0.0.0.0/0"
#   route_table_id         = aws_route_table.private.id

#   timeouts {
#     create = "5m"
#   }
# }
