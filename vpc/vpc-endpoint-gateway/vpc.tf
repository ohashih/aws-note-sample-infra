resource "aws_vpc" "sample-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "aws-note"
  }
}

resource "aws_subnet" "sample-public-subnet" {
  vpc_id            = aws_vpc.sample-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "aws-note-public"
  }
}

resource "aws_subnet" "sample-private-subnet" {
  vpc_id            = aws_vpc.sample-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "aws-note-private"
  }
}

resource "aws_internet_gateway" "sample-igw" {
  vpc_id = aws_vpc.sample-vpc.id
}

resource "aws_route_table" "sample-igw-route-table" {
  vpc_id = aws_vpc.sample-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample-igw.id
  }
}

resource "aws_route_table_association" "sample-public-route-table-association" {
  subnet_id      = aws_subnet.sample-public-subnet.id
  route_table_id = aws_route_table.sample-igw-route-table.id
}

resource "aws_route_table" "sample-private-route-table" {
  vpc_id = aws_vpc.sample-vpc.id
}

resource "aws_route_table_association" "sample-route-table-private-association" {
  subnet_id      = aws_subnet.sample-private-subnet.id
  route_table_id = aws_route_table.sample-private-route-table.id
}

resource "aws_vpc_endpoint" "sample-s3-gateway" {
  vpc_id          = aws_vpc.sample-vpc.id
  service_name    = "com.amazonaws.ap-northeast-1.s3"
  route_table_ids = [aws_route_table.sample-private-route-table.id]
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
