provider "aws" {
  region = "ap-southeast-1"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "PROD_ENV"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  
  }


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "DEV_ENV"
  cidr = "172.31.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["172.31.1.0/24", "172.31.2.0/24"]
  public_subnets  = ["172.31.101.0/24","172.31.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  
  }

