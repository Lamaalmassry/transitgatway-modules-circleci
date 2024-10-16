provider "aws" {
  region     = "us-east-1
}

module "vpc" {
  source = "./modules/vpc"

  vpc_1_cidr = var.vpc_1_cidr
  vpc_2_cidr = var.vpc_2_cidr
  vpc_3_cidr = var.vpc_3_cidr
}

module "subnets" {
  source = "./modules/subnets"

  vpc_1_id = module.vpc.vpc_1_id
  vpc_2_id = module.vpc.vpc_2_id
  vpc_3_id = module.vpc.vpc_3_id

  vpc_1_private_cidr = var.vpc_1_private_cidr
  vpc_2_private_cidr = var.vpc_2_private_cidr
  vpc_3_public_cidr  = var.vpc_3_public_cidr
}

module "transit_gateway" {
  source = "./modules/tgw"

  vpc_1_id        = module.vpc.vpc_1_id
  vpc_2_id        = module.vpc.vpc_2_id
  vpc_3_id        = module.vpc.vpc_3_id
  vpc_1_subnet_id = module.subnets.vpc_1_private_id
  vpc_2_subnet_id = module.subnets.vpc_2_private_id
  vpc_3_subnet_id = module.subnets.vpc_3_public_id
  vpc_1_cidr      = var.vpc_1_cidr
  vpc_2_cidr      = var.vpc_2_cidr
  vpc_3_cidr      = var.vpc_3_cidr
  igw_id          = module.igw.igw_id
}

module "ec2" {
  source          = "./modules/ec2"
  vpc_2_subnet_id = module.subnets.vpc_2_private_id
  vpc_3_subnet_id = module.subnets.vpc_3_public_id
  key_name        = var.key_name
  public_key_path = var.public_key_path
  vpc_3_id        = module.vpc.vpc_3_id
  vpc_2_id        = module.vpc.vpc_2_id
}

module "igw" {
  source          = "./modules/igw"
  vpc_3_id        = module.vpc.vpc_3_id
  vpc_3_public_id = module.subnets.vpc_3_public_id
}

