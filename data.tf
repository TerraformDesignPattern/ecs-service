// IMPORT ACCOUNT DATA
data "terraform_remote_state" "account" {
  backend = "s3"

  config {
    bucket = "${var.aws_account}-terraform-state"
    key    = "aws/terraform.tfstate"
    region = "us-east-1"
  }
}

// IMPORT VPC DATA
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.aws_account}-terraform-state"
    key    = "aws/${var.aws_region}/${var.vpc_name}/terraform.tfstate"
    region = "us-east-1"
  }
}

// IMPORT ECS CLUSTER DATA
data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"

  config {
    bucket = "${var.aws_account}-terraform-state"
    key    = "aws/${var.aws_region}/${var.vpc_name}/${var.environment_name}/ecs-cluster/terraform.tfstate"
    region = "us-east-1"
  }
}
