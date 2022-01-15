resource "aws_instance" "Dev" {
  ami           = "ami-08e4e35cccc6189f4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.Public0.id
  security_groups = aws_security_group.main.id

  tags = {
    Name = "l1"
  }
}

resource "aws_security_group" "main" {
  name        = "main"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["100.1.180.196/32"]
  }

  ingress {
    description      = "Allow internal traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "main"
  }
}

