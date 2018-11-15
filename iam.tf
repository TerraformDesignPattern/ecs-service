// CREATE ECS SERVICE IAM ROLE
resource "aws_iam_role" "ecs_service_iam_role" {
  name = "${var.environment_name}-${var.service_name}-ecs-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement":
  [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

// CREATE ECS SERVICE IAM ROLE POLICY
resource "aws_iam_role_policy" "ecs_service_iam_role_policy" {
  name = "${var.environment_name}-${var.service_name}-ecs-service-policy"
  role = "${aws_iam_role.ecs_service_iam_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "${data.terraform_remote_state.ecs_cluster.cloudwatch_log_group_arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

// CREATE ECS APPAUTOSCALING IAM ROLE
resource "aws_iam_role" "ecs_as_iam_role" {
  name = "${var.environment_name}-${var.service_name}-ecs-as-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

// CREATE ECS APPAUTOSCALING IAM ROLE POLICY
resource "aws_iam_role_policy" "ecs_as_iam_role_policy" {
  name = "${var.environment_name}-${var.service_name}-ecs-as-policy"
  role = "${aws_iam_role.ecs_as_iam_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:DescribeServices",
                "ecs:UpdateService"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:DescribeAlarms"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

// CREATE ECS TASK IAM ROLE
resource "aws_iam_role" "ecs_task_iam_role" {
  name = "${var.environment_name}-${var.service_name}-ecs-task-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
