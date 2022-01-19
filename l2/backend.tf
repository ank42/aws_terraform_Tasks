terraform {
  backend "s3" {
    bucket         = "my-bucket-for-tf-state"
    key            = "l2/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "for_state_lock"
    encrypt        = true
  }
}
