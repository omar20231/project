resource "aws_ecs_cluster" "ecs" {
  name = var.cluster

  setting {
    name  = local.setting_name
    value = local.value
  }
}
resource "aws_ecs_service" "fargate" {
  name            = var.cluster
  cluster         = aws_ecs_cluster.ecs.id
  launch_type = "FARGATE"
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  platform_version = "LATEST"
  scheduling_strategy = "REPLICA"

 
 
  network_configuration {
    assign_public_ip = false
    subnets = [var.priv-1,var.priv-2]
    security_groups = [var.security_group_id]
  }
  


  

  load_balancer {
   target_group_arn = var.target-group
    container_name   = local.name
    container_port   = local.port
  }

}

resource "null_resource" "wait_for_alb" {
  triggers = {
    alb_arn = var.alb
  }
}

resource "aws_ecs_task_definition" "service" {
  family = local.family
  requires_compatibilities = [local.requires_compatibilities]
  network_mode = local.network_mode
  cpu = local.cpu
  memory = local.memory
  execution_role_arn = data.aws_iam_role.execusion.arn
  container_definitions = jsonencode([
    {
      name      = local.name
      image     = "${data.aws_ecr_repository.thread.repository_url}:latest"
      cpu       = local.container_cpu
      memory    = local.memory
      essential = true
      portMappings = [
        {
          containerPort = local.port
          hostPort      = local.port
          protocol = "tcp"
        }
      ]
    }
  ])
  
  
}

data "aws_ecr_repository" "thread" {
  name= "project"
}
data "aws_iam_role" "execusion" {
  name = "ecsTaskExecutionRole"
}