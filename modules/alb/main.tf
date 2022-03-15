#configure security group
resource "aws_security_group" "alb_sg" {
  name   = "alb_sg"
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "alb_sg"
  }
}

#Configure application load balancer
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [data.terraform_remote_state.level1.outputs.public_subnet_id[1], data.terraform_remote_state.level1.outputs.public_subnet_id[0]]
  tags = {
    Name = "custom-alb"
  }
}

#Listener 
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.albtg.arn
  }

}

#create target groups
resource "aws_alb_target_group" "albtg" {
  name     = "albtg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.level1.outputs.vpc_id

  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 6
    interval = 10
  }

  tags = {
    Name = "target_group"
  }
}



#Creating target group attachment
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_alb_target_group.albtg.arn
  target_id        = var.instance_id
  port             = 80
}
