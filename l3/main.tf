module "alb" {
  source = "../modules/alb"

  vpc_id       = data.terraform_remote_state.level1.outputs.vpc_id
  instance_id  = data.terraform_remote_state.level2.outputs.instance_id
  subnet_ids   = data.terraform_remote_state.level1.outputs.public_subnet_id
}

