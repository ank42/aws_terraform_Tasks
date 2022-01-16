terraform {
  backend "s3" {
    bucket         = "my-bucket-for-tf-state"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "for_state_lock"
    encrypt        = true
  }
}
