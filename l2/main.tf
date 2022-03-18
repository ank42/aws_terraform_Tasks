data "terraform_remote_state" "level1" {
  backend = "s3"
  config = {
    bucket = "my-bucket-for-tf-state"
    key    = "l1/terraform.tfstate"
    region = "us-west-2"
  }
}

module "ec2" {
  source     = "../modules/ec2"
  vpc_ids    = data.terraform_remote_state.level1.outputs.vpc_id
  subnet_ids = [data.terraform_remote_state.level1.outputs.public_subnet_id[1], data.terraform_remote_state.level1.outputs.public_subnet_id[0]]

}

module "alb" {
  source      = "../modules/alb"
  instance_id = module.ec2.instance_id
  subnet_ids  = [data.terraform_remote_state.level1.outputs.public_subnet_id[1], data.terraform_remote_state.level1.outputs.public_subnet_id[0]]
  vpc_ids     = data.terraform_remote_state.level1.outputs.vpc_id
}

module "asg" {
  source               = "../modules/asg"
  subnet_ids           = [data.terraform_remote_state.level1.outputs.public_subnet_id[1], data.terraform_remote_state.level1.outputs.public_subnet_id[0]]
  alb_target_group_arn = module.alb.alb_target_group_arn

}
