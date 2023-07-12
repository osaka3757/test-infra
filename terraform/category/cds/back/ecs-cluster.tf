resource "aws_ecs_cluster" "main" {
  name = var.ecr_container_name
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

resource "aws_cloudwatch_log_group" "ecs_log_group_api" {
  name = "/ecs/${var.ecr_container_name}"
}
