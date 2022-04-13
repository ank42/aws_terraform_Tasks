output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.Public.*.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "private_subnet" {
  description = "Private Subnet ID"
  value       = aws_subnet.Private.*.id
}

output "vpc_cidr" {
  description = "vpc cidr output"
  value       = aws_vpc.main.cidr_block

}