resource "aws_ecs_cluster" "ecs" {
  name = "${var.env_prefix}-eshop-ecs"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data "aws_ecr_image" "ecrimage" {
  repository_name = aws_ecr_repository.ecr.name
  image_tag = "${var.build_number}"
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
      "image" : "${aws_ecr_repository.ecr.repository_url}:${var.build_number}@${data.aws_ecr_image.ecrimage.image_digest}",
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
  force_new_deployment = true
  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.sg.id]
    subnets          = [aws_subnet.subnet.id]
  }
}