resource "aws_iam_policy" "policy" {
  name        = var.name
  

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
policy = jsonencode({
   "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
})

}

