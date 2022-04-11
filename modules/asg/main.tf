data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

#configure security group
resource "aws_security_group" "asg_sg" {
  name   = "asg_sg"
  vpc_id = var.vpc_ids

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "asg_sg"
  }
}

resource "aws_launch_template" "t3micro" {
  name_prefix            = "t3micro"
  image_id               = data.aws_ami.amazon-linux-2.id
  instance_type          = "t3.micro"
  key_name               = "MyKeyPair"
  vpc_security_group_ids = [aws_security_group.asg_sg.id]
  user_data              = filebase64("${path.module}/data.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.S3_profile.name
  }

  tags = {
    Name = "Test-LaunchTemplate"
  }
}

resource "aws_autoscaling_group" "MyASG" {
  desired_capacity    = 3
  max_size            = 5
  min_size            = 3
  vpc_zone_identifier = [var.private_subnet_ids[1], var.private_subnet_ids[0]]
  target_group_arns   = [var.alb_target_group_arn]

  launch_template {
    id      = aws_launch_template.t3micro.id
    version = "$Latest"
  }
}

resource "aws_iam_instance_profile" "S3_profile" {
  name = "S3_profile"
  role = aws_iam_role.S3_fullaccess.name
}

resource "aws_iam_role" "S3_fullaccess" {
  name = "S3_fullaccess"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy =jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "s3.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })

  tags = {
    Name = "S3Access"
  }
}
