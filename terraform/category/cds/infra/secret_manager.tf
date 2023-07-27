resource "aws_secretsmanager_secret" "customer" {
  name = "${var.env}-customer"
}

resource "aws_secretsmanager_secret_version" "customer_version" {
  secret_id = aws_secretsmanager_secret.customer.id
  secret_string = jsonencode({
    cognito-resion-name   = var.customer_cognito_resion_name,
    cognito-client-id     = var.customer_cognito_client_id,
    cognito-client-secret = var.customer_cognito_client_secret
  })
}

resource "aws_secretsmanager_secret" "account_manager" {
  name = "${var.env}-account-manager"
}

resource "aws_secretsmanager_secret_version" "account_manager_version" {
  secret_id = aws_secretsmanager_secret.account_manager.id
  secret_string = jsonencode({
    cognito-resion-name   = var.account_manager_cognito_resion_name,
    cognito-client-id     = var.account_manager_cognito_client_id,
    cognito-client-secret = var.account_manager_cognito_client_secret
  })
}
