data "terraform_remote_state" "level1" {
  backend = "s3"
  config = {
    bucket = "my-bucket-for-tf-state"
    key    = "l1/terraform.tfstate"
    region = "us-west-2"
  }
}
