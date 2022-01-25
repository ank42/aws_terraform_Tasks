output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.Public.*.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}
