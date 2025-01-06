resource "aws_instance" "sample-public-instance" {
  ami                         = data.aws_ami.al2023.id
  key_name                    = "kurage"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.sample-public-subnet.id
  security_groups             = [aws_security_group.sample-public-security-group.id]
  associate_public_ip_address = true
  tags = {
    Name = "aws-note-vpc-public"
  }
}

resource "aws_instance" "sample-pirvate-instance" {
  ami             = data.aws_ami.al2023.id
  key_name        = "kurage"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.sample-private-subnet.id
  security_groups = [aws_security_group.sample-private-security-group.id]
  private_ip      = "10.0.2.10"
  tags = {
    Name = "aws-note-vpc-private"
  }
}

resource "aws_security_group" "sample-public-security-group" {
  name        = "public"
  description = "allow ssh and http"
  vpc_id      = aws_vpc.sample-vpc.id
  ingress {
    description = "Allow HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }

  ingress {
    description = "Allow SSH"
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }
  egress {
    description = "Allow all outbound traffic"
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_security_group" "sample-private-security-group" {
  name        = "private"
  description = "allow http and Limited SSH"
  vpc_id      = aws_vpc.sample-vpc.id
  ingress {
    description = "Allow HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }

  ingress {
    description     = "Allow SSH"
    security_groups = [aws_security_group.sample-public-security-group.id]
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
  }
  egress {
    description = "Allow all outbound traffic"
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}
