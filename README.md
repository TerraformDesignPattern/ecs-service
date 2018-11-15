# ECS-Service Terraform Module

## Root Module Files

__main.tf__

```
module "ecs_service" {
  source = "git::ssh://git@github.com:TerraformDesignPattern/ecs-cluster"

  aws_account      = "${var.aws_account}"
  aws_region       = "${var.aws_region}"
  environment_name = "${var.environment_name}"
  vpc_name         = "${var.vpc_name}"

  service_name     = "${element(split("-", var.service_name), 0)}"
  tier             = "${element(split("-", var.service_name), 1)}"

  alb_listener_rule_priority = "${var.alb_listener_rule_priority}"
  container_cpu              = "${var.container_cpu}"
  container_memory           = "${var.container_memory}"
  container_port             = "${var.container_port}"
  desired_count              = "${var.desired_count}"
  image_url                  = "${var.image_url}"
  image_tag                  = "${var.image_tag}"
}
```

__variables.tf__

Replace with the service's variables. NOTE - leave the `image_tag` blank as it will be passed in by the Jenkins job.

```
variable "image_tag" {}

variable "aws_account" {}

variable "aws_region" {}

variable "environment_name" {}

variable "service_name" {}

variable "vpc_name" {}

variable "alb_listener_rule_priority" {
  default  = "991"
}

variable "container_cpu" {
  default = 1024
}

variable "container_memory" {
  default = 2048
}

variable "container_port" {
  default = "8101"
}

variable "desired_count" {
  default = "2"
}

variable "image_url" {
  default = "jonbrouse/awesome-service"
}

variable "service_name" {
  default = "awesome-service"
}
```
