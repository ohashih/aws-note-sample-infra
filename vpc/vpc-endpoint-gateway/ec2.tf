resource "aws_instance" "sample-instance" {
  ami                         = data.aws_ami.al2023.id
  key_name                    = "kurage"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.sample-subnet.id
  security_groups             = [aws_security_group.sample-security-group.id]
  associate_public_ip_address = true
  tags = {
    Name = "aws-note-vpc"
  }
}

resource "aws_instance" "sample-instance2" {
  ami             = data.aws_ami.al2023.id
  key_name        = "kurage"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.sample-subnet-2.id
  security_groups = [aws_security_group.sample-security-group-private.id]
  tags = {
    Name = "aws-note-vpc"
  }
}

resource "aws_security_group" "sample-security-group-private" {
  name        = "allow ssh private"
  description = "allow ssh private"
  vpc_id      = aws_vpc.sample-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "sample-private-ingress" {
  security_group_id = aws_security_group.sample-security-group-private.id
  referenced_security_group_id = aws_security_group.sample-security-group.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = "22"
}

resource "aws_vpc_security_group_egress_rule" "sample-private-egress" {
  security_group_id = aws_security_group.sample-security-group-private.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_security_group" "sample-security-group" {
  name        = "allow_ssh"
  description = "allow ssh"
  vpc_id      = aws_vpc.sample-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "sample-ingress" {
  security_group_id = aws_security_group.sample-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "sample-ingress-http" {
  security_group_id = aws_security_group.sample-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "sample-ingress-icmp" {
  security_group_id = aws_security_group.sample-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}

resource "aws_vpc_security_group_egress_rule" "sample-egress" {
  security_group_id = aws_security_group.sample-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
