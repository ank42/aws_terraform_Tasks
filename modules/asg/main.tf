data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "t3micro-template" {
  name_prefix   = "t3micro"
  image_id      = "ami-0359b3157f016ae46"
  instance_type = "t3.micro"
  key_name                    = "MyKeyPair"
  network_interfaces {
    associate_public_ip_address = true
  }


  tags = {
    Name = "1stasg"
  }
}


resource "aws_autoscaling_group" "MyASG" {
  
  desired_capacity   = 3
  max_size           = 5
  min_size           = 3
  vpc_zone_identifier = [data.terraform_remote_state.level1.outputs.public_subnet_id[1], data.terraform_remote_state.level1.outputs.public_subnet_id[0]]

  launch_template {
    id      = aws_launch_template.t3micro-template.id
    version = "$Latest"
  }
}

/*
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
*/