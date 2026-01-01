module "network" {
  source             = "./modules/network"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  az                 = var.az
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "iam" {
  source = "./modules/iam"
}


module "compute" {
  source               = "./modules/compute"
  subnet_id            = module.network.subnet_id
  ami_id               = var.ami_id
  key_name             = var.key_name
  security_groups      = module.security.security_group_ids
  iam_instance_profile = module.iam.instance_profile_name

}






