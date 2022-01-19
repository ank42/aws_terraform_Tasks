
output "p_o" {
  description = "Public Subnet ID"
  value = aws_subnet.Public[0].id
  
}