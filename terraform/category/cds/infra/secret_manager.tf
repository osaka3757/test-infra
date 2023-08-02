resource "aws_secretsmanager_secret" "customer" {
  name = "${var.env}-customer"
}

resource "aws_secretsmanager_secret_version" "customer_version" {
  secret_id = aws_secretsmanager_secret.customer.id
  secret_string = jsonencode({
    app-title                      = var.customer_app_title,
    cognito-customer-region-name   = var.cognito_customer_region_name,
    cognito-customer-client-id     = var.cognito_customer_client_id,
    cognito-customer-client-secret = var.cognito_customer_client_secret,
    cors-origins                   = var.customer_cors_origins
  })
}

resource "aws_secretsmanager_secret" "account_manager" {
  name = "${var.env}-account-manager"
}

resource "aws_secretsmanager_secret_version" "account_manager_version" {
  secret_id = aws_secretsmanager_secret.account_manager.id
  secret_string = jsonencode({
    app-title                             = var.account_manager_app_title
    cognito-account-manager-region-name   = var.cognito_account_manager_region_name,
    cognito-account-manager-client-id     = var.cognito_account_manager_client_id,
    cognito-account-manager-client-secret = var.cognito_account_manager_client_secret,
    cognito-account-manager-user-pool-id  = var.cognito_account_manager_user_pool_id,
    account-manager-cors-origins          = var.account_manager_cors_origins
  })
}
