resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name="ECS-terra"
  }
}
resource "aws_subnet" "public-1" {
  vpc_id     =aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "public-alb-2A"
  }
}
resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "public2-alb-2B"
  }
}
resource "aws_subnet" "priv" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "Private"
  }
}
resource "aws_subnet" "priv-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "Private"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "gateway"
  }
}
resource "aws_route_table" "ig" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
    
  } 

  tags = {
    Name = "public"
  }
}
resource "aws_route_table" "priv" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}
resource "aws_eip" "NAT" {
  domain   = "vpc"
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.NAT.id
  subnet_id     = aws_subnet.public-1.id

  tags = {
    Name = "gw NAT"
  }

  # 
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.ig.id
}
resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.ig.id
}
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.priv.id
  route_table_id = aws_route_table.priv.id
}
resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.priv-2.id
  route_table_id = aws_route_table.priv.id
}
resource "aws_security_group" "ALB-2" {
  name        = "ALB-2"
  description = "Allow http and https traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ALB-2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.ALB-2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.ALB-2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ALB-2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.ALB-2.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" 
}

resource "aws_security_group" "ecs" {
  name        = "ecs"
  description = "only allow ecs"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ecs"
  }
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4-1" {
  security_group_id = aws_security_group.ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6-1" {
  security_group_id = aws_security_group.ecs.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
resource "aws_security_group_rule" "example" {
  type              = "ingress"
  from_port         = 0
  to_port           = 3000
  protocol          = "tcp"
  #cidr_blocks       = [aws_vpc.main]
  source_security_group_id = aws_security_group.ALB-2.id
  security_group_id = aws_security_group.ecs.id
}




module "ecs"{
  source = "./modules/ecs"
  target-group = module.ALB.target_group
  alb = module.ALB.alb
  security_group_id = aws_security_group.ecs.id
  priv-1 = aws_subnet.priv.id
  priv-2 = aws_subnet.priv-2.id

}


module "IAM" {
  source = "./modules/IAM"
  
}
module "ALB" {
  source = "./modules/ALB"
  vpc_cidr = var.vpc_cidr
  domain = var.domain
  cert =module.ACM.cert
  #cert = aws_acm_certificate.alm.arn
  route-53 =data.aws_route53_zone.primary.zone_id
  security-group = aws_security_group.ALB-2.id
  subnet-1 = aws_subnet.public-1.id
  subnet-2 = aws_subnet.public-2.id
  vpc_id = aws_vpc.main.id
}
module "ACM"{
  source= "./modules/ACM"

}
data "aws_route53_zone" "primary"  {
  name = var.domain
}
#now connect the securty group to the ecs and the subnets to ecs and the alb
#alm as module 
#Task deffinision cant get ecr, so sg for ecs need to outbound 0.0.0.0/0, chatgpt notes
