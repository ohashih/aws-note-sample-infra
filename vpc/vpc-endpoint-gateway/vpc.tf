resource "aws_vpc" "sample-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "aws-note"
  }
}

resource "aws_subnet" "sample-subnet" {
  vpc_id            = aws_vpc.sample-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "aws-note"
  }
}

resource "aws_subnet" "sample-subnet-2" {
  vpc_id            = aws_vpc.sample-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "aws-note-private"
  }
}

resource "aws_network_acl" "sample-network-acl" {
  vpc_id     = aws_vpc.sample-vpc.id
  subnet_ids = [aws_subnet.sample-subnet.id]
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_network_acl" "sample-network-acl-private" {
  vpc_id     = aws_vpc.sample-vpc.id
  subnet_ids = [aws_subnet.sample-subnet-2.id]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.1.0/24"
    from_port  = 22
    to_port    = 22
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_internet_gateway" "sample-igw" {
  vpc_id = aws_vpc.sample-vpc.id
}

resource "aws_route_table" "sample-route-table" {
  vpc_id = aws_vpc.sample-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample-igw.id
  }
}

resource "aws_route_table_association" "sample-route-table-association" {
  subnet_id      = aws_subnet.sample-subnet.id
  route_table_id = aws_route_table.sample-route-table.id
}

resource "aws_route_table" "sample-private-s3-route-table" {
  vpc_id = aws_vpc.sample-vpc.id
}

resource "aws_vpc_endpoint" "sample-gateway-s3" {
  vpc_id          = aws_vpc.sample-vpc.id
  service_name    = "com.amazonaws.ap-northeast-1.s3"
  route_table_ids = [aws_route_table.sample-private-s3-route-table.id]
  policy          = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
POLICY
}
