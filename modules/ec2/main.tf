data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "Dev" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t3.micro"
  subnet_id       = data.terraform_remote_state.level1.outputs.public_subnet_id[1]
  security_groups = [aws_security_group.main.id]
  key_name        = "MyKeyPair"
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd && sudo systemctl enable httpd

EOF

  tags = {
    Name = "l1"
  }
}

resource "aws_security_group" "main" {
  name        = "main"
  description = "Allow inbound traffic"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["100.1.180.196/32"]
  }
  ingress {
    description = "SSH from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["100.1.180.196/32"]
  }

  ingress {
    description = "Allow internal traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
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
