// CREATE ALB DNS ALIAS
resource "aws_route53_record" "internal_route53_record" {
  count   = "${lookup(var.boolean_count, var.create_internal_listener)}"
  zone_id = "${data.terraform_remote_state.account.primary_zone_id}"
  name    = "${var.environment_name}-${var.service_name}-${data.terraform_remote_state.vpc.aws_region_shortname}.${data.terraform_remote_state.account.domain_name}."
  type    = "A"

  alias {
    name                   = "${data.terraform_remote_state.ecs_cluster.internal_alb_dns_name}"
    zone_id                = "${data.terraform_remote_state.ecs_cluster.internal_alb_zone_id}"
    evaluate_target_health = false
  }
}

// CREATE ALB DNS ALIAS
resource "aws_route53_record" "external_route53_record" {
  count   = "${lookup(var.boolean_count, var.create_external_listener)}"
  zone_id = "${data.terraform_remote_state.account.primary_zone_id}"
  name    = "${var.external_domain_name}.${data.terraform_remote_state.account.domain_name}."
  type    = "A"

  alias {
    name                   = "${data.terraform_remote_state.ecs_cluster.external_alb_dns_name}"
    zone_id                = "${data.terraform_remote_state.ecs_cluster.external_alb_zone_id}"
    evaluate_target_health = false
  }
}
