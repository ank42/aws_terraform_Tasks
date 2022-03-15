module "ec2" {
  source = "../modules/ec2"

}

module "alb" {
  source      = "../modules/alb"
  instance_id = module.ec2.instance_id
}

module "asg" {
  source   = "../modules/asg"
  

}
