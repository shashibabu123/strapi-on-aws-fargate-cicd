variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "ecr_image" {}
variable "execution_role_arn" {
  description = "ARN of the IAM role to use for ECS task execution"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch Log Group name"
  type        = string
  default     = "/ecs/strapi"
}

variable "aws_region" {
  description = "AWS Region to deploy resources"
  type        = string
  default     = "us-east-1" # or change based on your region
}

variable "ecs_cluster_name" {
  description = "The ECS cluster name"
  type        = string
}

