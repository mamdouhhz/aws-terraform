module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr          = var.vpc_cidr
  sub_pub_cidr_list = var.sub_pub_cidr_list
  sub_prv_cidr_list = var.sub_prv_cidr_list
  azs               = var.azs
}

module "nat" {
  source             = "./modules/nat"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source             = "./modules/alb"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  alb_sg_id          = module.security_groups.alb_sg_id
  alb_internal_sg_id = module.security_groups.alb_internal_sg_id
  web_instance_ids   = module.compute.web_instance_ids
  app_instance_ids   = module.compute.app_instance_ids
}

module "compute" {
  source             = "./modules/ec2"
  ami                = var.ami
  instance_type      = var.instance_type
  key_name           = var.key_name
  private_key_path   = var.private_key_path
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  ec2_sg_id          = module.security_groups.ec2_sg_id
  app_sg_id          = module.security_groups.app_sg_id
}