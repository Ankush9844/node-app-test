module "vpc" {
  source      = "../modules/vpc"
  ProjectName = var.ProjectName
  cidrBlock   = var.cidrBlock
}

module "securityGroups" {
  source      = "../modules/security-groups"
  ProjectName = var.ProjectName
  vpcID       = module.vpc.vpcID
}

module "appLoadBalancer" {
  source                         = "../modules/alb"
  ProjectName                    = var.ProjectName
  vpcID                          = module.vpc.vpcID
  PublicSubnetIDs                = module.vpc.PublicSubnetIDs
  appLoadBalancerSecurityGroupID = module.securityGroups.appLoadBalancerSecurityGroupID
  defaultSSLCertificateARN       = var.defaultSSLCertificateARN
  frontendDomain                 = var.frontendDomain
}

module "ecsOnFargate" {
  source                    = "../modules/ecs-fargate"
  ProjectName               = var.ProjectName
  ecsFargateSecurityGroupID = module.securityGroups.ecsFagateSecurityGroupID
  fargateTargetGroupARN     = module.appLoadBalancer.fargateTargetGroupARN
  PublicSubnetIDs           = module.vpc.PublicSubnetIDs
  containerImage            = var.containerImage
  containerName             = var.containerName
  depends_on                = [module.vpc, module.appLoadBalancer]
}


module "codeBuildProject" {
  source           = "../modules/pipeline/codebuild"
  github_token     = var.github_token
  account_id       = var.account_id
  aws_region       = var.aws_region
  githubConnection = var.githubConnection
}

module "nodeAppPipeline" {
  source           = "../modules/pipeline/codepipeline"
  aws_region       = var.aws_region
  account_id       = var.account_id
  ecsClusterName   = module.ecsOnFargate.ecsClusterName
  ecsServiceName   = module.ecsOnFargate.ecsServiceName
  githubConnection = var.githubConnection
  codeBuildProject = module.codeBuildProject.codeBuildProjectName
  depends_on       = [module.codeBuildProject]
}
