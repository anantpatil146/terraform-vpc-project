provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  az                 = "ap-south-1a"
  env                = terraform.workspace
}

module "ec2" {
  source        = "./modules/ec2"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.subnet_id
  key_name      = "mykeypair"
  env           = terraform.workspace
}

output "instance_id" {
  value = module.ec2.instance_id
}
