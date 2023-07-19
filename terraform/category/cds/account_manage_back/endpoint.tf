# resource "aws_vpc_endpoint" "ecr_api" {
#   service_name      = "com.amazonaws.ap-northeast-1.ecr.api"
#   vpc_endpoint_type = "Interface"
#   vpc_id            = data.terraform_remote_state.infra.outputs.vpc_id
#   subnet_ids = [
#     data.terraform_remote_state.infra.outputs.private_subnet_1a_id,
#     data.terraform_remote_state.infra.outputs.private_subnet_1c_id
#   ]

#   security_group_ids = [
#     aws_security_group.https.id,
#     aws_security_group.http.id
#   ]

#   private_dns_enabled = true

#   tags = {
#     "Name" = "${var.customer_prefix}-ecr-api-endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "ecr_dkr" {
#   service_name      = "com.amazonaws.ap-northeast-1.ecr.dkr"
#   vpc_endpoint_type = "Interface"
#   vpc_id            = data.terraform_remote_state.infra.outputs.vpc_id
#   subnet_ids = [
#     data.terraform_remote_state.infra.outputs.private_subnet_1a_id,
#     data.terraform_remote_state.infra.outputs.private_subnet_1c_id
#   ]

#   security_group_ids = [
#     aws_security_group.https.id,
#     aws_security_group.http.id
#   ]

#   private_dns_enabled = true

#   tags = {
#     "Name" = "${var.customer_prefix}-ecr-dkr-endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "logs" {
#   service_name      = "com.amazonaws.ap-northeast-1.logs"
#   vpc_endpoint_type = "Interface"

#   vpc_id = data.terraform_remote_state.infra.outputs.vpc_id

#   subnet_ids = [
#     data.terraform_remote_state.infra.outputs.private_subnet_1a_id,
#     data.terraform_remote_state.infra.outputs.private_subnet_1c_id
#   ]

#   security_group_ids = [
#     aws_security_group.https.id,
#     aws_security_group.http.id
#   ]
#   private_dns_enabled = true

#   tags = {
#     "Name" = "${var.customer_prefix}-logs"
#   }
# }

# resource "aws_vpc_endpoint" "s3" {
#   service_name      = "com.amazonaws.ap-northeast-1.s3"
#   vpc_endpoint_type = "Gateway"
#   vpc_id            = data.terraform_remote_state.infra.outputs.vpc_id
#   route_table_ids   = [data.terraform_remote_state.infra.outputs.private_route_table_id]

#   tags = {
#     "Name" = "${var.customer_prefix}-s3-endpoint"
#   }

#   policy = <<POLICY
# {
#     "Statement": [
#         {
#             "Action": "*",
#             "Effect": "Allow",
#             "Resource": "*",
#             "Principal": "*"
#         }
#     ]
# }
# POLICY
# }

# resource "aws_security_group" "https" {
#   name        = "https"
#   description = "https"
#   vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

#   egress {
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 0
#     protocol    = "-1"
#     to_port     = 0
#   }

#   ingress {
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 443
#     protocol    = "tcp"
#     to_port     = 443
#   }

#   timeouts {}

#   tags = {
#     Name = "${var.customer_prefix}-https"
#   }
# }

# resource "aws_security_group" "http" {
#   name        = "http"
#   description = "http"
#   vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

#   egress {
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 0
#     protocol    = "-1"
#     to_port     = 0
#   }

#   ingress {
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 80
#     protocol    = "tcp"
#     to_port     = 80
#   }

#   timeouts {}

#   tags = {
#     Name = "${var.customer_prefix}-http"
#   }
# }

# # SSM, EC2Messages, and SSMMessages endpoints are required for Session Manager
# resource "aws_vpc_endpoint" "ssm" {
#   count  = 1
#   vpc_id = data.terraform_remote_state.infra.outputs.vpc_id
#   subnet_ids = [
#     data.terraform_remote_state.infra.outputs.private_subnet_1a_id,
#     data.terraform_remote_state.infra.outputs.private_subnet_1c_id
#   ]
#   service_name      = "com.amazonaws.ap-northeast-1.ssm"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.https.id,
#     aws_security_group.http.id
#   ]

#   private_dns_enabled = false
#   tags = {
#     Name = "${var.customer_prefix}-ssm-endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "ssmmessages" {
#   count  = 1
#   vpc_id = data.terraform_remote_state.infra.outputs.vpc_id
#   subnet_ids = [
#     data.terraform_remote_state.infra.outputs.private_subnet_1a_id,
#     data.terraform_remote_state.infra.outputs.private_subnet_1c_id
#   ]
#   service_name      = "com.amazonaws.ap-northeast-1.ssmmessages"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.https.id,
#     aws_security_group.http.id
#   ]

#   private_dns_enabled = false
#   tags = {
#     Name = "${var.customer_prefix}-ssmmessages-endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "secrets_manager" {
#   service_name = "com.amazonaws.ap-northeast-1.secretsmanager"
#   security_group_ids = [
#     aws_security_group.https.id,
#     aws_security_group.http.id
#   ]
#   policy = jsonencode(
#     {
#       Statement = [
#         {
#           Action    = "*"
#           Effect    = "Allow"
#           Principal = "*"
#           Resource  = "*"
#         },
#       ]
#     }
#   )
#   private_dns_enabled = true
#   route_table_ids     = []
#   subnet_ids = [
#     data.terraform_remote_state.infra.outputs.private_subnet_1a_id,
#     data.terraform_remote_state.infra.outputs.private_subnet_1c_id
#   ]
#   vpc_endpoint_type = "Interface"
#   vpc_id            = data.terraform_remote_state.infra.outputs.vpc_id

#   tags = {
#     Name = "${var.customer_prefix}-secrets-manager-endpoint"
#   }
# }
