# Policy para visualização do eks
module "allow_eks_access_iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name          = "allow-eks-access"
  create_policy = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


# Role Para Administração do eks
module "eks_admins_iam_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  role_name         = "eks-admin"
  create_role       = true
  role_requires_mfa = false

  custom_role_policy_arns = [module.allow_eks_access_iam_policy.arn]

  trusted_role_arns = [
    "arn:aws:iam::${local.account_id}:root"
  ]
}


# Política do IAM que permite que o usuário assuma a função do IAM "eks-admin".
module "allow_assume_eks_admins_iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"
  # version = "5.3.1"

  name          = "allow-assume-eks-admin-iam-role"
  create_policy = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = module.eks_admins_iam_role.iam_role_arn
      },
    ]
  })
}



# Criar o grupo de administração do eks e já adicionar o usuário do azure devops para execução das esteiras.
module "eks_admins_iam_group" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  # version = "5.3.1"

  name                              = "eks-admin"
  attach_iam_self_management_policy = false
  create_group                      = true
  group_users                       = local.user_eks_admin
  custom_group_policy_arns          = [module.allow_assume_eks_admins_iam_policy.arn]
}

