terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}


output "az" {
  value = data.aws_availability_zones.available

}
