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
