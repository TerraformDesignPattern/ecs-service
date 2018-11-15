// CREATE ALB TARGET GROUP
resource "aws_alb_target_group" "alb_target_group" {
  name     = "${var.environment_name}-${local.short_name}-tg"
  port     = "${var.container_port}"
  protocol = "HTTP"
  vpc_id   = "${data.terraform_remote_state.vpc.vpc_id}"

  health_check {
    protocol = "${var.health_check_protocol}"

    matcher = "${var.health_check_matcher}"
    path    = "${var.health_check_endpoint}"

    timeout             = 29
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }
}

// CREATE INTERNAL ALB LISTENER RULE (ENABLED DEFAULT)
resource "aws_alb_listener_rule" "internal_alb_listener_rule" {
  count        = "${lookup(var.boolean_count, var.create_internal_listener)}"
  listener_arn = "${data.terraform_remote_state.ecs_cluster.internal_alb_listener_arn}"
  priority     = "${var.alb_listener_rule_priority}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.environment_name}-${var.service_name}*.${data.terraform_remote_state.account.domain_name}"]
  }
}

// CREATE EXTERNAL ALB LISTENER RULE (DISABLED DEFAULT)
resource "aws_alb_listener_rule" "external_alb_listener_rule" {
  count        = "${lookup(var.boolean_count, var.create_external_listener)}"
  listener_arn = "${data.terraform_remote_state.ecs_cluster.external_alb_listener_arn}"
  priority     = "${var.alb_listener_rule_priority}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.external_domain_name}*.${data.terraform_remote_state.account.domain_name}"]
  }
}
