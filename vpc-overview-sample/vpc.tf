resource "aws_vpc" "sample-vpc" {
  cidr_block = "10.0.0.0/16"
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

# resource "aws_network_acl" "sample-network-acl" {
#   vpc_id     = aws_vpc.sample-vpc.id
#   subnet_ids = [aws_subnet.sample-subnet.id]
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 22
#     to_port    = 22
#   }
#
#   ingress {
#     protocol   = "icmp"
#     rule_no    = 200
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }
#
#   egress {
#     protocol   = "-1"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }
# }

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

resource "aws_main_route_table_association" "smple-route-table-association" {
  vpc_id         = aws_vpc.sample-vpc.id
  route_table_id = aws_route_table.sample-route-table.id
}

