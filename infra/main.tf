data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "us-east-1"

  vpc_cidr_block = var.vpc_cidr
  azs_to_use     = slice(data.aws_availability_zones.available.names, 0, 3)

  eks_cluster_name     = "eks-${var.environment}"
  eks_version          = "1.30"
  geral_nodegroup_name = "ndgrp-geral-${var.environment}"
  geral_instance_types = ["t3.micro", "t2.micro"]

  tags = {
    Example     = local.name
    GithubRepo  = "github.com/wandermaia/desafio-aws"
    Environment = var.environment
    Terraform   = "true"
  }
}
