output "appLoadBalancerSecurityGroupID" {
  value = aws_security_group.appLoadBalancerSecurityGroup.id
}

output "ecsFagateSecurityGroupID" {
  value = aws_security_group.ecsFargateSecurityGroup.id
}
