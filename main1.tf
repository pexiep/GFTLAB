module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"

  name = "NON-PROD"
  cidr = "10.1.0.0/16"

  azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets     = ["10.1.10.0/24", "10.1.11.0/24", "10.1.22.0/24"]
  public_subnets      = ["10.1.0.0/24","10.1.1.0/24", "10.1.2.0/24"]
  database_subnets    = ["10.1.100.0/24", "10.1.110.0/24", "10.1.220.0/24"]

  enable_nat_gateway  = true
  single_nat_gateway  = true
  }

  
  module "eks1" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"
  cluster_version = "1.17"
  cluster_name    = "test1"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc1.vpc_id
    
  worker_groups = [
    {
      name                          = "worker-group1-1"
      instance_type                 = "t3.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 1
    },
    {
      name                          = "worker-group1-2"
      instance_type                 = "t3.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 1
    },
        {
      name                          = "worker-group1-3"
      instance_type                 = "t3.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 1
    },
  ]
}