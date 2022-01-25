variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_ids" {
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_ids" {
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}
