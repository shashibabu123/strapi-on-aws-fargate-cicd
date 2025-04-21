# ALB Security Group (allows internet traffic on ports 80 and 1337)
resource "aws_security_group" "strapi_alb_sg" {
  name        = "strapi-alb-sg-shashi"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Task Security Group (allows only ALB to connect on port 1337)
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg-shashi"
  description = "Allow Strapi traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.strapi_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Application Load Balancer
resource "aws_lb" "strapi_alb" {
  name               = "strapi-alb"
  internal           = false
  load_balancer_type = "application"
  # security_groups    = [aws_security_group.strapi_alb_sg.id]
  security_groups = ["sg-087a419c5a81404bd"] # <- Use the correct one you want
  subnets            = var.subnet_ids
  
   depends_on = [aws_security_group.strapi_alb_sg]
}

# Target Group for ECS
resource "aws_lb_target_group" "strapi_tg" {
  name        = "strapi-tg"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
    port = "1337"
  }
}

# Listener for port 1337
resource "aws_lb_listener" "strapi_listener" {
  load_balancer_arn = aws_lb.strapi_alb.arn
  port              = 1337
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi_tg.arn
  }
}

