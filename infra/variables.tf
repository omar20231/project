
locals {
  public="10.1.2.0/24"
  Public-2="10.1.4.0/24"
  Private="10.1.3.0/24"
/*policy=<<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*"
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "arn:aws:s3:::omar-ecs-project"
        }
    ]
}
EOF*/
validation_method="DNS"
tags="test"
}
variable "vpc_cidr" {
  type = string
  
}
variable "domain" {
  type = string
  
}


