################################################################
# Create IAM Role for ECS TaskExecution                        #
################################################################

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionPolicy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

################################################################
# Create ECS Cluster                                           #
################################################################

resource "aws_ecs_cluster" "main" {
  name = var.ProjectName
}

################################################################
# Create ECS Task Defination for Conatainer                    #
################################################################

resource "aws_ecs_task_definition" "fargateTaskDefination" {
  family                   = "fargateTaskDefination"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = jsonencode([
    {
      name      = var.containerName
      image     = var.containerImage
      essential = true
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      
    }
  ])
}

################################################################
# Create ECS Service for Conatiner                             #
################################################################

resource "aws_ecs_service" "fargateService" {
  name            = "fargateService"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.fargateTaskDefination.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = concat(var.PublicSubnetIDs)
    security_groups = [var.ecsFargateSecurityGroupID]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.fargateTargetGroupARN
    container_name   = var.containerName
    container_port   = 3000
  }

  depends_on = [aws_ecs_task_definition.fargateTaskDefination]
}

