module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "vpc-${var.environment}"
  cidr = var.vpc_cidr

  azs = local.azs_to_use

  # cidrsubnet(prefix, newbits, netnum)
  database_subnets = [for k, v in local.azs_to_use : cidrsubnet(local.vpc_cidr_block, 8, k)]
  private_subnets  = [for k, v in local.azs_to_use : cidrsubnet(local.vpc_cidr_block, 8, k + 4)]
  public_subnets   = [for k, v in local.azs_to_use : cidrsubnet(local.vpc_cidr_block, 8, k + 8)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags gerais
  tags = merge(local.tags, {
    Name = "vpc-${var.environment}"
  })


  # Tags para EKS
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" : "1",
    "kubernetes.io/cluster/eks-${var.environment}" : "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" : "1",
    "kubernetes.io/cluster/eks-${var.environment}" : "shared"
  }

}
