# account_managerの環境変数に使用しているため、削除は要注意
# TODO infraに移動させるか要検討
resource "aws_cognito_user_pool" "customer_user_pool" {
  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  name = "${var.customer_prefix}-user-pool"
  # ユーザー確認を行う際にEmail or 電話で自動検証を行うための設定。Emailを指定。
  username_attributes      = ["email"]
  auto_verified_attributes = []

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true # 英小文字
    require_numbers                  = true # 数字
    require_symbols                  = true # 記号
    require_uppercase                = true # 英大文字
    temporary_password_validity_days = 7    # 初期登録時の一時的なパスワードの有効期限
  }

  mfa_configuration = "OFF"

  admin_create_user_config {
    # ユーザーに自己サインアップを許可する。
    # TODO ユーザーテストまでにはtrueで実装すること
    allow_admin_create_user_only = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  email_configuration {
    # https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/user-pool-email.html
    # ユーザー招待時などに使用するメールの設定。Cognito(デフォルト) or SES が使用できる。
    # デフォルトだと送信数などに制限があるため、本番で使用する場合は、SESを使用した方がよい。
    email_sending_account = "COGNITO_DEFAULT"
  }

  # TODO 本番リリースでは有効化
  # deletion_protection = "ACTIVE"

  # 必須の属性
  schema {
    name                = "given_name"
    attribute_data_type = "String"
    required            = true
  }

  schema {
    name                = "family_name"
    attribute_data_type = "String"
    required            = true
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
  }

  # カスタム属性
  # https://registry.terraform.io/providers/-/aws/latest/docs/resources/cognito_user_pool#schema
  schema {
    name                     = "account_id"
    attribute_data_type      = "Number"
    developer_only_attribute = false
    mutable                  = true

    number_attribute_constraints {
      min_value = 0
      max_value = 9999
    }
  }

  schema {
    name                     = "customer_authority"
    attribute_data_type      = "Number"
    developer_only_attribute = false
    mutable                  = true

    number_attribute_constraints {
      min_value = 0
      max_value = 1
    }
  }

  schema {
    name                     = "delete_flag"
    attribute_data_type      = "Number"
    developer_only_attribute = false
    mutable                  = true

    number_attribute_constraints {
      min_value = 0
      max_value = 1
    }
  }

  schema {
    name                     = "family_name_kana"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true

    string_attribute_constraints {
      max_length = "2048"
      min_length = "1"
    }
  }

  schema {
    name                     = "given_name_kana"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true

    string_attribute_constraints {
      max_length = "2048"
      min_length = "1"
    }
  }

  tags = {
    Env = var.env
  }
}

resource "aws_cognito_user_pool_client" "customer_user_pool_client" {
  name            = "${var.customer_prefix}-user-pool-client"
  user_pool_id    = aws_cognito_user_pool.customer_user_pool.id
  generate_secret = true

  # # OAuthを今回しようしないため設定しない。
  # allowed_oauth_flows                  = []
  # allowed_oauth_flows_user_pool_client = false
  # allowed_oauth_scopes                 = []
  # callback_urls                        = []

  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
  ]
  # logout_urls                   = []
  # prevent_user_existence_errors = "ENABLED"

  # 更新トークンの期限
  refresh_token_validity        = 30
  access_token_validity         = 24
  id_token_validity             = 24
  prevent_user_existence_errors = "ENABLED"
  supported_identity_providers  = []

  # 属性の読み取り有無設定。
  read_attributes = [
    "address",
    "birthdate",
    "custom:account_id",
    "custom:customer_authority",
    "custom:delete_flag",
    "custom:family_name_kana",
    "custom:given_name_kana",
    "email",
    "email_verified",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "phone_number_verified",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]

  # 属性の書き有無設定。
  write_attributes = [
    "address",
    "birthdate",
    "custom:account_id",
    "custom:customer_authority",
    "custom:delete_flag",
    "custom:family_name_kana",
    "custom:given_name_kana",
    "email",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]
}

# resource "aws_cognito_identity_pool" "identity_pool" {
#   identity_pool_name = "${var.identity_pool_name}_${var.env}"

#   # 認証していないユーザーには使用させないため、falseを設定。
#   allow_unauthenticated_identities = false

#   openid_connect_provider_arns = []
#   saml_provider_arns           = []
#   supported_login_providers    = {}
#   tags                         = {}

#   cognito_identity_providers {
#     client_id               = aws_cognito_user_pool_client.user_pool_client.id
#     provider_name           = "cognito-idp.ap-northeast-1.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
#     server_side_token_check = false
#   }
# }
