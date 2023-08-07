resource "aws_secretsmanager_secret" "customer" {
  name = "${var.customer_prefix}-secrets-manager"
}

resource "aws_secretsmanager_secret_version" "customer_version" {
  secret_id = aws_secretsmanager_secret.customer.id
  secret_string = jsonencode({
    app-title                      = var.customer_app_title,
    customer-origin-whitelist      = var.customer_origin_whitelist
    cognito-customer-region-name   = var.cognito_customer_region_name,
    cognito-customer-client-id     = aws_cognito_user_pool_client.customer_user_pool_client.id,
    cognito-customer-client-secret = aws_cognito_user_pool_client.customer_user_pool_client.client_secret,
  })
}
