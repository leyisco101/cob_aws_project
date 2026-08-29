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


# ECS Cluster


resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.project_name}-cluster"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-cluster"
    }
  )
}


# CloudWatch Log Group


resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${local.project_name}"
  retention_in_days = 7

  tags = local.common_tags
}


# ECS Task Execution Role Trust Policy


data "aws_iam_policy_document" "ecs_execution_assume_role" {
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


# ECS Task Execution Role


resource "aws_iam_role" "ecs_execution_role" {
  name = "${local.project_name}-ecs-execution-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_execution_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-ecs-execution-role"
    }
  )
}


# Attach AWS ECS Execution Policy


resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role = aws_iam_role.ecs_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ECS Security Group


resource "aws_security_group" "ecs_security_group" {
  name        = "${local.project_name}-ecs-sg"
  description = "Security group for COB ECS workloads"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-ecs-sg"
    }
  )
}


# Allow ECS Outbound Traffic


resource "aws_vpc_security_group_egress_rule" "ecs_outbound" {
  security_group_id = aws_security_group.ecs_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow ECS tasks outbound access"
}


# ECS Task Definition


resource "aws_ecs_task_definition" "ecs_task" {
  family = "${local.project_name}-task"

  requires_compatibilities = [
    "FARGATE"
  ]

  network_mode = "awsvpc"

  cpu    = var.cpu
  memory = var.memory

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "${local.project_name}-container"
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = local.common_tags
}


# Current AWS Region


data "aws_region" "current" {}


# ECS Service


resource "aws_ecs_service" "ecs_service" {
  name    = "${local.project_name}-service"
  cluster = aws_ecs_cluster.ecs_cluster.id

  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = var.desired_count

  launch_type = "FARGATE"

  network_configuration {
    subnets = var.private_subnet_ids

    security_groups = [
      aws_security_group.ecs_security_group.id
    ]

    assign_public_ip = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_execution_policy
  ]

  tags = local.common_tags
}
