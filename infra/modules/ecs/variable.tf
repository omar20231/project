variable "cluster" {
    type=string
    default = "thread"
  
}

locals {
  setting_name = "containerInsights"
  value= "enabled"
  family= "service"
  requires_compatibilities ="FARGATE"
  network_mode = "awsvpc"
  cpu = 256
  memory = 512
  name = "latest"
  port=3000
  container_cpu = 10
}
variable "target-group" {
  type = string
  
}


variable "alb" {
  type = string
  
}
variable "security_group_id" {
  type = string
  
}
variable "priv-1"{
  type= string
}
variable "priv-2" {
  type = string
  
}