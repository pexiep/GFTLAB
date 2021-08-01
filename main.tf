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

  enable_nat_gateway  = true
  single_nat_gateway  = true
  }
 
 ###EKS Creation
  
  module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  cluster_version = "1.17"
  version = "17.1.0"
  cluster_name    = test
  subnets         = "10.2.11.0/24"


  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t3.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 1
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t3.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 1
    },
        {
      name                          = "worker-group-3"
      instance_type                 = "t3.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 1
    },
  ]
}
