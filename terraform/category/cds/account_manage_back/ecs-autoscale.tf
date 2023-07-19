# resource "aws_appautoscaling_target" "ecsfargate" {
#   service_namespace  = "ecs"
#   resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.ecs.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   min_capacity       = 1
#   max_capacity       = 10
# }

# resource "aws_appautoscaling_policy" "scale" {
#   name               = "${local.ecs.cluster_name}-scale"
#   resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.ecs.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
#   policy_type        = "TargetTrackingScaling"

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }

#     // CPUの平均使用率が60%になるように維持する
#     target_value       = 60
#     // スケールインの間隔は60秒空ける
#     scale_in_cooldown  = 60
#     // スケールアウトの間隔は30秒空ける
#     scale_out_cooldown = 30
#   }

#   depends_on = [aws_appautoscaling_target.ecsfargate]
# }

# resource "aws_appautoscaling_policy" "ecsfargate_scale_out" {
#   name               = "${local.project_name}_cpu_scale_out"
#   policy_type        = "StepScaling"
#   service_namespace  = aws_appautoscaling_target.ecsfargate.service_namespace
#   resource_id        = aws_appautoscaling_target.ecsfargate.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecsfargate.scalable_dimension

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 30
#     metric_aggregation_type = "Maximum"

#     #step_adjustment {
#     #  metric_interval_lower_bound = 0
#     #  scaling_adjustment          = 1
#     #}
#     // CPUの平均使用率が70%-80%の場合コンテナを3つ増やす
#     step_adjustment {
#       metric_interval_lower_bound = 0
#       metric_interval_upper_bound = 10
#       scaling_adjustment          = 3
#     }

#     // CPUの平均使用率が80%-90%の場合コンテナを5つ増やす
#     step_adjustment {
#       metric_interval_lower_bound = 10
#       metric_interval_upper_bound = 20
#       scaling_adjustment          = 5
#     }

#     // CPUの平均使用率が90%-の場合コンテナを10増やす
#     step_adjustment {
#       metric_interval_lower_bound = 20
#       scaling_adjustment          = 10
#     }
#   }
# }

# resource "aws_appautoscaling_policy" "ecsfargate_scale_in" {
#   name               = "${local.project_name}_cpu_scale_in"
#   policy_type        = "StepScaling"
#   service_namespace  = aws_appautoscaling_target.ecsfargate.service_namespace
#   resource_id        = aws_appautoscaling_target.ecsfargate.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecsfargate.scalable_dimension

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 30
#     metric_aggregation_type = "Average"

#     step_adjustment {
#       metric_interval_upper_bound = 0
#       scaling_adjustment          = -1
#     }
#   }
# }

# # autoscale CloudWatch
# resource "aws_cloudwatch_metric_alarm" "ecsfargate_cpu_high" {
#   alarm_name          = "ecs-${local.project_name}-cpu_utilization_high"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   period              = "60"
#   statistic           = "Average"
#   // Step ScalingのCPU平均使用率の閾値の基準は40%
#   threshold           = "40"

#   dimensions = {
#     ClusterName = aws_ecs_cluster.main.name
#     ServiceName = aws_ecs_service.ecs.name
#   }

#   alarm_actions = [
#     aws_appautoscaling_policy.ecsfargate_scale_out.arn
#   ]
# }

# resource "aws_cloudwatch_metric_alarm" "ecsfargate_cpu_low" {
#   alarm_name          = "ecs-${local.project_name}-cpu_utilization_low"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   period              = "30"
#   statistic           = "Average"
#   threshold           = "15"

#   dimensions = {
#     ClusterName = aws_ecs_cluster.main.name
#     ServiceName = aws_ecs_service.ecs.name
#   }

#   alarm_actions = [
#     aws_appautoscaling_policy.ecsfargate_scale_in.arn
#   ]
# }
