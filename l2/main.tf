module "ec2" {
  source = "../modules/ec2"

  vpc_id    = data.terraform_remote_state.level1.outputs.vpc_id
  subnet_id = data.terraform_remote_state.level1.outputs.public_subnet_id[0]
}
