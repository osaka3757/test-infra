resource "aws_ecs_task_definition" "account_manage_task" {
  family                   = "${var.account_manage_prefix}-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task_execution.arn
  cpu                      = "256"
  memory                   = "1024"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "${var.account_manage_prefix}-container",
    "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/${aws_ecr_repository.account_manage_api.name}:1.0.0",
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
        "awslogs-group": "/ecs/${var.account_manage_prefix}",
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "${var.account_manage_prefix}",
        "awslogs-region": ${data.aws_region.name}
        "awslogs-create-group": true
      }
    },
    "linuxParameters": {
      "initProcessEnabled": true
    }
  }
]
TASK_DEFINITION
}

resource "aws_iam_role" "task_execution" {
  name = "${var.account_manage_prefix}-TaskExecution"

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
