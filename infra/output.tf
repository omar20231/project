output "vpc" {
    description = "vpc-id"
    value = aws_vpc.main.id

  
}

output "subnet-pub-1" {
    description = "public-1"
    value= aws_subnet.public-1
  
}
output "subnet-pub-2" {
    description = "public-2"
    value = aws_subnet.public-2
  
}
output "security_group_id-1" {
    description = "ALB"
    value = aws_security_group.ALB-2.id
  
}
output "security_group_id-2" {
    description = "ECS"
    value = aws_security_group.ecs.id
  
}