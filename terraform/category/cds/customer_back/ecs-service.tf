resource "aws_ecs_service" "customer_api" {
  name                               = "${var.customer_prefix}-service"
  cluster                            = aws_ecs_cluster.customer_api.id
  task_definition                    = "${aws_ecs_task_definition.customer_task.family}:${aws_ecs_task_definition.customer_task.revision}"
  desired_count                      = 1
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  platform_version                   = "LATEST"
  enable_execute_command             = true

  # ECSタスクへ設定するネットワークの設定
  network_configuration {
    subnets = [
      data.terraform_remote_state.infra.outputs.private_subnet_1a_id,
      data.terraform_remote_state.infra.outputs.private_subnet_1c_id
    ]
    security_groups = [aws_security_group.ecs.id]
  }

  # タスク起動時のヘルスチェック猶予期間
  health_check_grace_period_seconds = 360

  # ECSタスクの起動後に紐付けるELBターゲットグループ
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_blue.arn
    container_name   = "${var.customer_prefix}-container"
    container_port   = 80
  }

  scheduling_strategy = "REPLICA"

  # deployment_controller {
  #   type = "CODE_DEPLOY"
  # }

  lifecycle {
    ignore_changes = [
      platform_version,
      desired_count,
      task_definition,
      # load_balancer,
    ]
  }
  propagate_tags = "TASK_DEFINITION"

  depends_on = [
    aws_lb_target_group.alb_target_blue
  ]

}
