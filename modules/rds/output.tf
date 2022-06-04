output "rds_username" {
  description = "rds username"
  value       = local.rds_creds.username
  sensitive   = true
}

output "rds_password" {
  description = "rds password"
  value       = local.rds_creds.password
  sensitive   = true
}