[
  {
    "cpu": ${container_cpu},
    "environment": [${environment_variables}
    ],
    "image": "${image_url}:${image_tag}",
    "memory": ${container_memory},
    "name": "${container_name}",
    "portMappings": [
      {
        "containerPort": ${container_port}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${cloudwatch_log_group_name}",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "${stream_prefix}"
      }
    },
    "mountPoints": [${mount_points}
    ]
  }
]
