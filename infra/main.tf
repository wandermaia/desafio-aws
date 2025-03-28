data "aws_availability_zones" "available" {}

locals {
  name   = "wandermaia-desafio-aws-${var.environment}"
  region = var.regiao

  vpc_cidr_block = var.vpc_cidr
  azs_to_use     = slice(data.aws_availability_zones.available.names, 0, 3)

  eks_cluster_name               = "eks-${var.environment}"
  eks_version                    = var.eks_cluster_version
  geral_nodegroup_name           = "ndgrp-geral-${var.environment}"
  geral_nodegroup_instance_types = var.instance_types_ndgrp_geral
  geral_nodegroup_capacity_type  = var.capacity_type_ndgrp_geral
  security_group_name_mysql      = "security-group-mysql-${var.environment}"
  security_group_name_ec2        = "security-group-ec2-${var.environment}"

  tags = {
    Projeto     = local.name
    GithubRepo  = "github.com/wandermaia/desafio-aws"
    Environment = var.environment
    Terraform   = "true"
  }
}
