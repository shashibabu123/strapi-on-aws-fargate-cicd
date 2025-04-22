terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.95.0"  
    }
  }
}

resource "aws_ecs_cluster" "strapi" {
  name = "strapi-cluster"
}

