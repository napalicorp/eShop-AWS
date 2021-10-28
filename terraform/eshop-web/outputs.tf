output "cluster_arn" {
  description = "ECS Cluster Arn"
  value       = aws_ecs_cluster.ecs.arn
}

output "service_name" {
  description = "ECS Service name"
  value       = aws_ecs_service.service.name
}