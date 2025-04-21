variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "ecr_image" {}
variable "execution_role_arn" {
  description = "ARN of the IAM role to use for ECS task execution"
  type        = string
}

