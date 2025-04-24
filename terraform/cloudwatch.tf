resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = var.log_group_name
  retention_in_days = 7

  lifecycle {
    create_before_destroy = true
    prevent_destroy        = false
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "strapi-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This alarm triggers if CPU exceeds 80%"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = aws_ecs_service.strapi.name
  }
}

