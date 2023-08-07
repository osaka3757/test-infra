output "cognito_customer_client_id" {
  value = aws_cognito_user_pool_client.customer_user_pool_client.id
}

output "cognito_customer_client_secret" {
  value     = aws_cognito_user_pool_client.customer_user_pool_client.client_secret
  sensitive = true
}

output "cognito_customer_user_pool_id" {
  value = aws_cognito_user_pool.customer_user_pool.id
}
