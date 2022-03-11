output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = module.vpc.public_subnet_id
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}


