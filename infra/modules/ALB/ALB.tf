resource "aws_lb" "ALB" {
  name               = local.name
  internal           = false
  load_balancer_type = local.load_balancer_type
  security_groups    = [var.security-group]
  subnets            = [var.subnet-1 , var.subnet-2] 
  

  enable_deletion_protection = true
  

 

  tags = {
    Environment = local.tags
  }
}
/*resource "aws_s3_bucket" "remote-2" {
  bucket = "omar-ecs"
  
  tags = {
    Name        = "ecs-station"
    Environment = "Dev"
  }

}*/
/*resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.remote-2.id
  policy = local.policy
}*/



/*resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
   
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]

  })
}*/


resource "aws_lb_target_group" "ip" {
  name        = local.name
  port        = local.port
  protocol    = local.protocol
  target_type = local.target_type
  vpc_id      = var.vpc_id
  health_check {
healthy_threshold = "3"
interval = "30"
protocol = "HTTP"
matcher = "200"
timeout = "3"
path = "/health"
unhealthy_threshold = "2"
port = "3000"
}
}




/*resource "aws_subnet" "subnet" {
  vpc_id     = data.aws_security_group.selected.vpc_id
  cidr_block = var.vpc_cidr
}*/
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = local.port
  protocol          = local.protocol

  default_action {
    type = local.redirect

    redirect {
      port        = local.port-2
      protocol    = local.protocol_2
      status_code = local.status_code
    }
  }
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = local.port-2
  protocol          = local.protocol_2
  certificate_arn   = var.cert

  default_action {
    type = local.default_action

    forward {
      target_group {
        arn    = aws_lb_target_group.ip.arn
        weight = local.weight
      }
      
    }
  }
}


/*resource "aws_route53_record" "www" {
  zone_id = var.route-53
  name    = "www.${var.domain}"
  type    = var.route_type

   alias {
    name                   = aws_lb.ALB.name
    zone_id                = aws_lb.ALB.zone_id
    evaluate_target_health = true
  }
}
*/
/*resource "aws_route53_record" "example" {
  allow_overwrite = local.true
  name            = var.domain
  ttl             = local.ttl
  type            = local.ns
  zone_id         = var.route-53

  records = [
    aws_lb.ALB.arn
  ]
}*/
resource "aws_route53_record" "www" {
  zone_id = var.route-53
  name    = var.domain
  type    = local.type

  alias {
    name                   = aws_lb.ALB.dns_name
    zone_id                = aws_lb.ALB.zone_id
    evaluate_target_health = local.true
  }
}