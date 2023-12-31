resource "aws_ecs_task_definition" "customer_task" {
  family                   = "${var.customer_prefix}-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task_execution.arn
  cpu                      = "256"
  memory                   = "512"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "${var.project_name}-customer-container",
    "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/${aws_ecr_repository.customer_api.name}:1.0.0",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${var.customer_prefix}",
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "${var.customer_prefix}"
      }
    },
    "linuxParameters": {
      "initProcessEnabled": true
    },
    "secrets": [
      {
        "name": "APP_TITLE",
        "valueFrom": "${aws_secretsmanager_secret.customer.arn}:app-title::"
      },
            {
        "name": "COGNITO_CUSTOMER_REGION_NAME",
        "valueFrom": "${aws_secretsmanager_secret.customer.arn}:cognito-customer-region-name::"
      },
      {
        "name": "COGNITO_CUSTOMER_CLIENT_ID",
        "valueFrom": "${aws_secretsmanager_secret.customer.arn}:cognito-customer-client-id::"
      },
      {
        "name": "COGNITO_CUSTOMER_CLIENT_SECRET",
        "valueFrom": "${aws_secretsmanager_secret.customer.arn}:cognito-customer-client-secret::"
      },
      {
        "name": "ORIGIN_WHITELIST",
        "valueFrom": "${aws_secretsmanager_secret.customer.arn}:customer-origin-whitelist::"
      }
    ]
  }
]
TASK_DEFINITION
}

resource "aws_iam_role" "task_execution" {
  name = "${var.customer_prefix}-TaskExecution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "task_execution" {
  role = aws_iam_role.task_execution.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel",
        "ecr:BatchImportUpstreamImage",
        "ecr:CreateRepository",
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt",
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
