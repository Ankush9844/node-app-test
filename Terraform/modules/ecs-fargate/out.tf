output "ecsClusterName" {
  value = aws_ecs_cluster.main.name
}
output "ecsServiceName" {
  value = aws_ecs_service.fargateService.name
}
