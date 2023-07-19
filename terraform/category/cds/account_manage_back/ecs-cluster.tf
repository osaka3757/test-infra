resource "aws_ecs_cluster" "account_manage_api" {
  name = "${var.account_manage_prefix}-cluster"
  #capacity_providers = ["FARGATE"]
  #capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  #default_capacity_provider_strategy {
  #  base              = 0
  #  capacity_provider = "FARGATE"
  #  weight            = 1
  #}
  #default_capacity_provider_strategy {
  #  base              = 0
  #  capacity_provider = "FARGATE_SPOT"
  #  weight            = 1
  #}
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "ecs_log_group_account_manage_api" {
  name = "/ecs/${var.account_manage_prefix}"
}
