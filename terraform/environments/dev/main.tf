module "vpc" {
  source        = "../../modules/vpc"
  project_name      = var.project_name
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
}
module "ec2" {
  source = "../../modules/ec2"
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id 
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  subnet_id        = module.vpc.subnet_id
  key_name         = var.key_name
  root_volume_size = var.root_volume_size
  admin_ip         = var.admin_ip
}