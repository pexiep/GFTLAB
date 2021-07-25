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

  name = "PROD_ENV"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  
  }


module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"

  name = "DEV_ENV"
  cidr = "172.31.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["172.31.1.0/24", "172.31.2.0/24"]
  public_subnets  = ["172.31.101.0/24","172.31.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  
  }

  #### CREATE EKS for 2 VPC
  
data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "my-prod-env" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-eks-prod-env"
  cluster_version = "1.17"
  subnets         = ["subnet-005f89dbe623cc8ea", "subnet-0ce5ea0073394d88c"]
  vpc_id          = "vpc-0b16574d98c11e5fc"

  worker_groups = [
    {
      instance_type = "m2.micro"
      asg_max_size  = 3
    }
  ]
}
  
 module "my-dev-env" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-eks-dev-env"
  cluster_version = "1.17"
  subnets         = ["subnet-0ccdcf2498f1ea2d8", "subnet-0948a6444ac4dd85c"]
  vpc_id          = "vpc-02f1976631032a0e6"

  worker_groups = [
    {
      instance_type = "m2.micro"
      asg_max_size  = 3
    }
  ]
}
