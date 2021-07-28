terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile    = "default"
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}
####CREATE 2 VPC for PROD and DEV
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "PROD"
  cidr = "10.2.0.0/16"

  azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets     = ["10.2.10.0/24", "10.2.11.0/24", "10.2.22.0/24"]
  public_subnets      = ["10.2.0.0/24", "10.2.1.0/24", "10.2.2.0/24"]
  database_subnets    = ["10.2.100.0/24", "10.2.110.0/24", "10.2.220.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  one_nat_gateway_per_az = false
  }


module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"

  name = "NON-PROD"
  cidr = "10.1.0.0/16"

  azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets     = ["10.1.10.0/24", "10.1.11.0/24", "10.1.22.0/24"]
  public_subnets      = ["10.1.0.0/24","10.1.1.0/24", "10.1.2.0/24"]
  database_subnets    = ["10.1.100.0/24", "10.1.110.0/24", "10.1.220.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  one_nat_gateway_per_az = false
  }

 
