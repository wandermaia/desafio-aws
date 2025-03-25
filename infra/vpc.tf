module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "wandermaia-${var.environment}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]

  database_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnets  = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]

  database_subnet_names = ["database-subnet-${var.environment}-01", "database-${var.environment}-02", "database-${var.environment}-03"]
  private_subnet_names = ["private-subnet-${var.environment}-01", "private-subnet-${var.environment}-02", "private-subnet-${var.environment}-03"]
  public_subnet_names = ["public-subnet-${var.environment}-01", "public-subnet-${var.environment}-02", "public-subnet-${var.environment}-03"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Name        = "wandermaia-${var.environment}-vpc"
  }
}
