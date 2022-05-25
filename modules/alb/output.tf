output "alb_target_group_arn" {
  value = aws_alb_target_group.albtg.arn
}

output "dns_name" {
  value = aws_lb.alb.dns_name
  
}