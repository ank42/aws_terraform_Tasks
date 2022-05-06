output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = module.vpc.public_subnet_id
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet" {
  description = "Private Subnet ID"
  value       = module.vpc.private_subnet
}

output "vpc_cidr" {
  description = "vpc cidr output"
  value       = module.vpc.vpc_cidr

}
