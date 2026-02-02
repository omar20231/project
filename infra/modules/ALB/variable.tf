variable "vpc_id" {
    type= string
  
}
variable "vpc_cidr" {
    type = string
  
}
locals {
  name = "thread"
  load_balancer_type ="application"
  prefix = "test-lb"
  tags = "production"
  port = 80
  port-target=3000
  protocol = "HTTP"
  target_type= "ip"
  weight = 100 
  default_action ="forward"
  protocol_2 ="HTTPS"
  port-2= 443
  status_code = "HTTP_301"
  types= "Amazon_Issued"
  ttl= "300"
  redirect= "redirect"
  true= "true"
  ns ="NS"
  type="A"
  policy=jsonencode({
   
    Version: "2012-10-17",
    Statement: [
        {
            Effect: "Allow",
            Action: [
                "s3:*",
                "s3-object-lambda:*"
            ],
            Resource: "*"
        }
    ]

  })
}


/*variable "vpc_id" {
    type= string
  
}
*/
variable "domain" {
    type = string
  
}
variable "route_type" {
    type = string
    default = "A"
  
}


variable "route-53" {
  type= string
}

#route 53 issiue

variable "security-group" {
    type= string
  
}
variable "subnet-1" {
    type = string
  
}
variable "subnet-2" {
    type = string
  
}
variable "cert" {
    type = string
  
}