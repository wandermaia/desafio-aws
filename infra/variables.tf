variable "environment" {
  description = "Define em qual ambiente estamos trabalhando (DEV ou PRD)"
  type        = string
  nullable    = false
}

variable "vpc_cidr" {
  description = "CIDR que será utilizado para criar a VPC"
  type        = string
  nullable    = false
}

variable "eks_cluster_version" {
  description = "Versão do EKS que será utilizada na criação do cluster"
  type        = string
  nullable    = false
}

variable "regiao" {
  description = "Região onde será realizada a criação dos recursos"
  type        = string
  nullable    = false
}

variable "instance_types_ndgrp_geral" {
  description = "Tipos de instâncias para o nodegroup geral"
  type        = list(string)
  nullable    = false
}

variable "capacity_type_ndgrp_geral" {
  description = "Tipos de capacidade do nodegroup geral (SPOT ou ON_DEMAND)"
  type        = string
  nullable    = false
}


variable "geral_desired_size" {
  description = "Quantidade desejada de nodes desejados para o nodegroup geral"
  type        = string
  nullable    = false
}


variable "geral_min_size" {
  description = "Quantidade mínima de nodes desejados para o nodegroup geral"
  type        = string
  nullable    = false
}

variable "geral_max_size" {
  description = "Quantidade máxima de nodes desejados para o nodegroup geral"
  type        = string
  nullable    = false
}

