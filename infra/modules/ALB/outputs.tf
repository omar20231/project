output "target_group" {
  description = "target-group"
  value = aws_lb_target_group.ip.arn
}
output "alb" {
  description = "ALB"
  value = aws_lb.ALB.arn
  
}
/*output "bucket" {
  description = "bucket"
  value = aws_s3_bucket.remote-2.arn
  
}*/