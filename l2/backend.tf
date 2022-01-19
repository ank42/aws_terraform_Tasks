terraform {
  backend "s3" {
    bucket         = "my-bucket-for-tf-state"
    key            = "l2/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "for_state_lock"
    encrypt        = true
  }
}

data "terraform_remote_state" "level1" {
  backend = "s3"
  config = {
    bucket = "my-bucket-for-tf-state"
    key    = "l1/terraform.tfstate"
    region = "us-west-2"
  }
}