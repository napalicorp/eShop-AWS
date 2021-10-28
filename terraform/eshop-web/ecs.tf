resource "aws_ecs_cluster" "ecs" {
  name = "${var.env_prefix}-eshop-ecs"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      "name" : "eshopweb",
      "image" : "${aws_ecr_repository.ecr.repository_url}:${var.build_number}",
      "cpu" : 512,
      "memory" : 2048,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort" : 80,
          "protocol" : "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name             = "${var.env_prefix}-eshop-service"
  cluster          = aws_ecs_cluster.ecs.id
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  task_definition  = aws_ecs_task_definition.task.arn
  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.sg.id]
    subnets          = [aws_subnet.subnet.id]
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}