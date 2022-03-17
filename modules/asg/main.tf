data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "t3micro" {
  name_prefix   = "t3micro"
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = "t3.micro"
  key_name      = "MyKeyPair"

  tags = {
    Name = "Test-LaunchTemplate"
  }
}


resource "aws_autoscaling_group" "MyASG" {

  desired_capacity    = 3
  max_size            = 5
  min_size            = 3
  vpc_zone_identifier = [var.subnet_ids[1], var.subnet_ids[0]]

  launch_template {
    id      = aws_launch_template.t3micro.id
    version = "$Latest"
  }
}
