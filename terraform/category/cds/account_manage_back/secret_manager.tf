resource "aws_secretsmanager_secret" "account_manager" {
  name = "${var.account_manage_prefix}-secrets-manager"
}

resource "aws_secretsmanager_secret_version" "account_manager_version" {
  secret_id = aws_secretsmanager_secret.account_manager.id
  secret_string = jsonencode({
    app-title                             = var.account_manager_app_title
    cognito-account-manager-region-name   = var.cognito_account_manager_region_name
    cognito-account-manager-client-id     = aws_cognito_user_pool_client.account_manager_user_pool_client.id
    cognito-account-manager-client-secret = aws_cognito_user_pool_client.account_manager_user_pool_client.client_secret
    cognito-account-manager-user-pool-id  = aws_cognito_user_pool.account_manage_user_pool.id
    account-manager-origin-whitelist      = var.account_manager_origin_whitelist
    cognito-customer-region-name          = var.cognito_customer_region_name
    cognito-customer-client-id            = data.terraform_remote_state.customer.outputs.cognito_customer_client_id
    cognito-customer-client-secret        = data.terraform_remote_state.customer.outputs.cognito_customer_client_secret
    cognito-customer-user-pool-id         = data.terraform_remote_state.customer.outputs.cognito_customer_user_pool_id
  })
}
