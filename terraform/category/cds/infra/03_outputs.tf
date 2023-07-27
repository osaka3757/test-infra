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

# ------------------------------------------------------------#
#  SecretsManager ARN
# ------------------------------------------------------------#
output "secretsmanager_customer_arn" {
  value = aws_secretsmanager_secret.customer.arn
}

output "secretsmanager_account_manager_arn" {
  value = aws_secretsmanager_secret.account_manager.arn
}
