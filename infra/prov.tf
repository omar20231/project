terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.25.0"
    }
  }
}
/*resource "aws_s3_bucket" "remote" {
  bucket = "omar-ecs-project"
  
  tags = {
    Name        = "ecs-station"
    Environment = "Dev"
  }

}
resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.remote.id
  policy = local.policy
}
*/


















/*jsonencode({
   
    "Version"= "2012-10-17",
    "Statement"= [
        {
            "Effect"= "Allow",
            "Action"= [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource"= "*"
        }
    ]

})
}

*/
provider "aws" {
  # Configuration options
  region = "eu-west-2"
}