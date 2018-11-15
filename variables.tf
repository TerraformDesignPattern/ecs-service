variable "aws_account" {}

variable "aws_region" {}

variable "environment_name" {}

variable "image_url" {}

variable "image_tag" {}

variable "service_name" {}

variable "vpc_name" {}

variable "alb_listener_rule_priority" {
  default = 1
}

variable "appautoscaling_target_max_capacity" {
  default = 4
}

variable "appautoscaling_target_min_capacity" {
  default = 1
}

variable "boolean_count" {
  default = {
    "true"  = 1
    "false" = 0
  }
}

variable "container_port" {
  default = "8080"
}

variable "container_cpu" {
  default = 1024
}

variable "container_memory" {
  default = 1024
}

variable "create_external_listener" {
  default = "false"
}

variable "create_internal_listener" {
  default = "true"
}

variable "deployment_minimum_healthy_percent" {
  default = "100"
}

variable "deployment_maximum_percent" {
  default = "200"
}

variable "desired_count" {
  default = "1"
}

variable "environment_variables" {
  default = <<EOF
      {
        "name": "VARIBLE",
        "value": "variable_value"
      }
EOF
}

variable "external_domain_name" {
  default = ""
}

variable "mount_points" {
  default = ""
}

variable "task_role_arn" {
  default = "null"
}

variable "health_check_endpoint" {
  default = "/"
}

variable "health_check_matcher" {
  default = 200
}

variable "health_check_protocol" {
  default = "HTTP"
}

variable "scale_down_appautoscaling_policy_cooldown" {
  default = 300
}

variable "scale_down_appautoscaling_policy_metric_interval_lower_bound" {
  default = 0
}

variable "scale_down_appautoscaling_policy_scaling_adjustment" {
  default = -1
}

variable "scale_up_appautoscaling_policy_cooldown" {
  default = 300
}

variable "scale_up_appautoscaling_policy_metric_interval_lower_bound" {
  default = 0
}

variable "scale_up_appautoscaling_policy_scaling_adjustment" {
  default = 1
}

locals {
  short_name = "${substr(var.service_name, 0, min(12, length(var.service_name)))}"
}
