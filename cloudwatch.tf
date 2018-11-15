// CREATE SCALE UP CLOUDWATCH METRIC ALARM
resource "aws_cloudwatch_metric_alarm" "scale_up_cloudwatch_metric_alarm" {
  alarm_name          = "${aws_ecs_task_definition.ecs_task_definition.family}-cpu-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  alarm_actions       = ["${aws_appautoscaling_policy.scale_up_appautoscaling_policy.arn}"]

  dimensions {
    ClusterName = "${data.terraform_remote_state.ecs_cluster.ecs_cluster_name}"
    ServiceName = "${aws_ecs_service.ecs_service.name}"
  }
}

// CREATE SCALE DOWN CLOUDWATCH METRIC ALARM
resource "aws_cloudwatch_metric_alarm" "scale_down_cloudwatch_metric_alarm" {
  alarm_name          = "${aws_ecs_task_definition.ecs_task_definition.family}-cpu-utilization-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "5"
  alarm_actions       = ["${aws_appautoscaling_policy.scale_down_appautoscaling_policy.arn}"]

  dimensions {
    ClusterName = "${data.terraform_remote_state.ecs_cluster.ecs_cluster_name}"
    ServiceName = "${aws_ecs_service.ecs_service.name}"
  }
}

// This would create an alarm if there were no healthy intances of the task running.
#// CREATE TARGET GROUP METRIC ALARM
#resource "aws_cloudwatch_metric_alarm" "target_group_health_cloudwatch_metric_alarm" {
#  alarm_name                = "${var.service_name}-healthy-hosts"
#  comparison_operator       = "LessThanOrEqualToThreshold"
#  evaluation_periods        = "1"
#  metric_name               = "HealthyHostCount"
#  namespace                 = "AWS/ApplicationELB"
#  period                    = "60"
#  statistic                 = "Maximum"
#  threshold                 = "0"
#  alarm_description         = "Check the health of ${var.service_name} target group."
#  insufficient_data_actions = []
#
#  dimensions {
#    TargetGroup  = "${aws_alb_target_group.alb_target_group.arn_suffix}"
#    LoadBalancer = "${data.terraform_remote_state.ecs_cluster.alb_arn_suffix}"
#  }
#}
