locals {
  project_name = "${var.project}-${var.environment}"

  common_tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "COB"
    },
    var.tags
  )
}

# ECS Task Assume Role Policy


data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}


# Workload IAM Role


resource "aws_iam_role" "workload_role" {
  name = "${local.project_name}-workload-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-workload-role"
    }
  )
}


# Least-Privilege S3 Policy


data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    sid    = "ListBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      var.bucket_arn
    ]
  }

  statement {
    sid    = "ObjectAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "${var.bucket_arn}/*"
    ]
  }
}


# IAM Policy


resource "aws_iam_policy" "s3_access_policy" {
  name        = "${local.project_name}-s3-access-policy"
  description = "Least-privilege S3 access managed by COB"

  policy = data.aws_iam_policy_document.s3_access_policy.json

  tags = local.common_tags
}

# Attach Policy To Workload Role


resource "aws_iam_role_policy_attachment" "workload_s3_access" {
  role       = aws_iam_role.workload_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}