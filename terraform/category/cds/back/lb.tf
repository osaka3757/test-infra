resource "aws_lb" "alb" {
  name            = "${var.project_name}-alb"
  internal        = false
  security_groups = [aws_security_group.alb.id]
  subnets = [
    data.terraform_remote_state.infra.outputs.private_subnet_1a_id,
    data.terraform_remote_state.infra.outputs.private_subnet_1c_id
  ]
  load_balancer_type = "application"

  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    prefix  = "ald-lb-log"
    enabled = true
  }
}

resource "aws_lb_target_group" "lb_target_blue" {
  name        = "${var.project_name}-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id
  target_type = "ip"

  health_check {
    interval            = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
    port                = "traffic-port"
  }
  depends_on = [
    aws_lb.alb
  ]

}

resource "aws_lb_target_group" "lb_target_green" {
  name        = "${var.project_name}-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id
  target_type = "ip"

  health_check {
    interval            = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
    port                = "traffic-port"
  }

  depends_on = [
    aws_lb.alb
  ]
}

# Listeners
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  lifecycle {
    ignore_changes = [default_action]
  }

  default_action {
    target_group_arn = aws_lb_target_group.lb_target_blue.arn
    type             = "forward"
  }

  depends_on = [
    aws_lb.alb,
    aws_lb_target_group.lb_target_blue
  ]
}

# ALB LOG
resource "aws_s3_bucket" "alb_log" {
  bucket = "${var.project_name}-alb-log"
}

# ライフサイクルルールの設定
resource "aws_s3_bucket_lifecycle_configuration" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id

  rule {
    id     = "expiration-lifecycle"
    status = "Enabled"
    # 365日経過したファイルを自動削除
    expiration {
      days = "365"
    }
  }
}

# バケットポリシー
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]
    principals {
      type = "AWS"
      # ここにロードバランサーのリージョンに対応する AWSアカウントIDを記載する
      identifiers = ["582318560864"]
    }
  }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.bucket}"]
  }
}
