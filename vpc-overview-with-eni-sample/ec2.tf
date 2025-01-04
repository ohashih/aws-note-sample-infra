resource "aws_instance" "sample-instance" {
  ami           = data.aws_ami.al2023.id
  key_name      = "kurage"
  instance_type = "t2.micro"
  network_interface {
    network_interface_id = aws_network_interface.sample-interface.id
    device_index         = 0
  }
  tags = {
    Name = "aws-note-vpc-with-eip"
  }
}

resource "aws_eip" "sample-eip" {
  network_interface = aws_network_interface.sample-interface.id
  depends_on        = [aws_internet_gateway.sample-igw]
}

resource "aws_network_interface" "sample-interface" {
  subnet_id       = aws_subnet.sample-subnet.id
  security_groups = ["${aws_security_group.sample-security-group.id}"]
  private_ips     = ["10.0.1.10"]
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