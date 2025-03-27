
module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.eks_cluster_name
  cluster_version = local.eks_version

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  # EKS Addons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  # Habilita o usuário (ou role) que criou o cluster como administrador
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets


  # Determina se deve criar um OpenID Connect Provider para EKS para habilitar IRSA
  # Habilitando funções do IAM para contas de serviço.
  enable_irsa = true


  # Ajustando os valores default para os nodegroups
  eks_managed_node_group_defaults = {
    # disk_size = 20

    # Security Group adicional
    vpc_security_group_ids = aws_security_group.security_group_eks.id

    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 20
          volume_type           = "gp3"
          iops                  = 3000
          throughput            = 150
          encrypted             = true
          delete_on_termination = true
        }
      }
    }
  }

  # Criação dos nodegroups
  eks_managed_node_groups = {

    # Nodegroup de instâncias para recursos padrão. Utiliza instâncias Ondemand
    wrkr-01 = {
      name            = local.geral_nodegroup_name
      node_group_name = local.geral_nodegroup_name

      desired_size = 2
      min_size     = 2
      max_size     = 2

      instance_types = local.geral_instance_types
      capacity_type  = "ON_DEMAND"

      labels = {
        cluster-name   = local.eks_cluster_name
        nodegroup-name = local.geral_nodegroup_name
        components     = "geral"
        role           = "worker"
      }

      # Tags do Nodegroup
      tags = merge(local.tags, {
        Name = local.geral_nodegroup_name
      })
    }

  }

}


# Configurar kubeconfig do cluster criado
# Executa um comando na máquina local para configurar o acesso ao novo cluster criado.
resource "null_resource" "kubeconfig" {

  depends_on = [
    module.eks_cluster
  ]

  provisioner "local-exec" {
    command = "aws eks --region us-east-1 update-kubeconfig --name ${local.eks_cluster_name}"
  }
}

# Blueprints disponibilizados pela AWS para o diver csi para EBS e utilitários importantes para o cluster
# https://registry.terraform.io/modules/aws-ia/eks-blueprints-addons/aws/latest
module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16"

  cluster_name      = module.eks_cluster.cluster_name
  cluster_endpoint  = module.eks_cluster.cluster_endpoint
  cluster_version   = module.eks_cluster.cluster_version
  oidc_provider_arn = module.eks_cluster.oidc_provider_arn

  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
    }
  }

  enable_aws_load_balancer_controller = true
  enable_metrics_server               = true
  enable_cluster_autoscaler           = true


  # Para o caso do ingress controller, é necessário adicionar a tag nas subnets que o cluster irá utilizar:
  # kubernetes.io/role/internal-elb 1
  enable_ingress_nginx = true

}



module "ebs_csi_driver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.20"

  role_name_prefix = "ebs-csi-driver-"

  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks_cluster.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = local.tags
}



# Criação do storageclass do tipo que utiliza GP3 encriptado.
# Definido com o default
resource "kubernetes_storage_class_v1" "gp3" {

  depends_on = [
    module.eks_blueprints_addons
  ]

  metadata {
    name = "sc-ebs-gp3-encrypted"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
  parameters = {
    "encrypted" = "true"
    "fsType"    = "ext4"
    "type"      = "gp3"
  }
}