// CREATE TASK DEFINITION TEMPLATE
data "template_file" "task_definition" {
  template = "${file("${path.module}/task-definition.json.tpl")}"

  vars {
    aws_region                = "${var.aws_region}"
    image_tag                 = "${var.image_tag}"
    image_url                 = "${var.image_url}"
    cloudwatch_log_group_name = "${data.terraform_remote_state.ecs_cluster.cloudwatch_log_group_name}"
    container_cpu             = "${var.container_cpu}"
    container_memory          = "${var.container_memory}"
    container_name            = "${var.service_name}"
    container_port            = "${var.container_port}"
    domain_name               = "${data.terraform_remote_state.account.domain_name}"
    environment_name          = "${var.environment_name}"
    environment_variables     = "${var.environment_variables}"
    mount_points              = "${var.mount_points}"
    service_name              = "${var.service_name}"
    stream_prefix             = "${var.service_name}"
  }
}

// CREATE ECS TASK DEFINITION
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = "${var.environment_name}-${var.service_name}-${data.terraform_remote_state.vpc.aws_region_shortname}"
  container_definitions = "${data.template_file.task_definition.rendered}"
  task_role_arn         = "${aws_iam_role.ecs_task_iam_role.arn}"

  depends_on = [
    "data.template_file.task_definition",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

// CREATE ECS SERVICE
resource "aws_ecs_service" "ecs_service" {
  name                               = "${aws_ecs_task_definition.ecs_task_definition.family}"
  cluster                            = "${data.terraform_remote_state.ecs_cluster.ecs_cluster_id}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent         = "${var.deployment_maximum_percent}"
  task_definition                    = "${aws_ecs_task_definition.ecs_task_definition.arn}"
  desired_count                      = "${var.desired_count}"
  iam_role                           = "${aws_iam_role.ecs_service_iam_role.name}"

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb_target_group.id}"
    container_name   = "${var.service_name}"
    container_port   = "${var.container_port}"
  }

  depends_on = [
    //"aws_iam_role.ecs_service_iam_role",
    "aws_ecs_task_definition.ecs_task_definition",
  ]
}
