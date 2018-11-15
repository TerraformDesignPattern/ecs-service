// CREATE AUTOSCALING TARGET
resource "aws_appautoscaling_target" "appautoscaling_target" {
  max_capacity       = "${var.appautoscaling_target_max_capacity}"
  min_capacity       = "${var.appautoscaling_target_min_capacity}"
  resource_id        = "service/${data.terraform_remote_state.ecs_cluster.ecs_cluster_name}/${aws_ecs_task_definition.ecs_task_definition.family}"
  role_arn           = "${aws_iam_role.ecs_as_iam_role.arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [
    "aws_ecs_service.ecs_service",
  ]
}

// CREATE SCALE UP AUTOSCALING POLICY
resource "aws_appautoscaling_policy" "scale_up_appautoscaling_policy" {
  name               = "${aws_ecs_task_definition.ecs_task_definition.family}-scale-up"
  resource_id        = "service/${data.terraform_remote_state.ecs_cluster.ecs_cluster_name}/${aws_ecs_task_definition.ecs_task_definition.family}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "${var.scale_up_appautoscaling_policy_cooldown}"
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = "${var.scale_up_appautoscaling_policy_metric_interval_lower_bound}"
      scaling_adjustment          = "${var.scale_up_appautoscaling_policy_scaling_adjustment}"
    }
  }

  depends_on = [
    "aws_appautoscaling_target.appautoscaling_target",
  ]
}

// CREATE SCALE DOWN AUTOSCALING POLICY
resource "aws_appautoscaling_policy" "scale_down_appautoscaling_policy" {
  name               = "${aws_ecs_task_definition.ecs_task_definition.family}-scale-down"
  resource_id        = "service/${data.terraform_remote_state.ecs_cluster.ecs_cluster_name}/${aws_ecs_task_definition.ecs_task_definition.family}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "${var.scale_down_appautoscaling_policy_cooldown}"
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = "${var.scale_down_appautoscaling_policy_metric_interval_lower_bound}"
      scaling_adjustment          = "${var.scale_down_appautoscaling_policy_scaling_adjustment}"
    }
  }

  depends_on = [
    "aws_appautoscaling_target.appautoscaling_target",
  ]
}
