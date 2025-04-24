# ECS Task Definition with CloudWatch Logs
resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = var.ecr_image
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
      environment = [
        {
          name  = "APP_KEYS"
          value = "myKeyA,myKeyB"
        },
        {
          name  = "API_TOKEN_SALT"
          value = "your_generated_token"
        },
        {
          name  = "AUTH_SECRET"
          value = "your_auth_secret"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs/strapi"
        }
      }
    }
  ])
}

# ECS Service Definition
resource "aws_ecs_service" "strapi" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.strapi.id
  task_definition = aws_ecs_task_definition.strapi.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.strapi_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_tg.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  depends_on = [
    aws_lb_listener.strapi_listener,
  ]
}

