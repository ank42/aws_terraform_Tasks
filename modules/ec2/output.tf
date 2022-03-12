output "instance_id" {
  description = "instance ID"
  value       = aws_instance.Dev.id

}

output "instance_public_ip" {
  description = "instance ID"
  value       = aws_instance.Dev.public_ip
}
