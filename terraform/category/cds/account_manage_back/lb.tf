resource "aws_lb" "alb" {
  name            = "${var.account_manage_prefix}-alb"
  internal        = false
  security_groups = [aws_security_group.alb.id]
  subnets = [
    data.terraform_remote_state.infra.outputs.public_subnet_1a_id,
    data.terraform_remote_state.infra.outputs.public_subnet_1c_id
  ]
  load_balancer_type = "application"

  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    prefix  = "ald-lb-log"
    enabled = true
  }
}

resource "aws_lb_target_group" "alb_target_blue" {
  name        = "${var.account_manage_prefix}-blue"
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
  # depends_on = [
  #   aws_lb.alb
  # ]
}

resource "aws_lb_target_group" "alb_target_green" {
  name        = "${var.account_manage_prefix}-green"
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

  # depends_on = [
  #   aws_lb.alb
  # ]
}

# Listeners
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  lifecycle {
    ignore_changes = [default_action]
  }

  default_action {
    target_group_arn = aws_lb_target_group.alb_target_blue.arn
    type             = "forward"
  }

  # depends_on = [
  #   aws_lb.alb,
  #   aws_lb_target_group.alb_target_blue
  # ]
}

# Listener Rule
resource "aws_lb_listener_rule" "blue_alb_listener_rule_allowed_ip" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_blue.arn
  }

  condition {
    source_ip { values = var.allowed_ip_address }
  }
}

resource "aws_lb_listener_rule" "blue_alb_listener_rule_denied_ip" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 20

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "{}"
      status_code  = "404"
    }
  }

  condition {
    source_ip { values = var.denied_ip_address }
  }
}

# resource "aws_lb_listener_rule" "green_alb_listener_rule_ip" {
#   listener_arn = aws_lb_listener.alb_listener.arn

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_target_green.arn
#   }

#   condition {
#     source_ip { values = var.allowed_ip_address }
#   }
# }

# ALB LOG
resource "aws_s3_bucket" "alb_log" {
  bucket = "${var.account_manage_prefix}-alb-log"
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
