# Namespace para instalação do Signoz.
resource "kubernetes_namespace_v1" "ns_signoz" {

  depends_on = [
    null_resource.kubeconfig
  ]
  metadata {
    name = local.observability_namespace_k8s
  }

  # Ignorando as alterações que forem feitas nos labels dos namespaces. O Rancher, por exemplo adiciona labels conforme o projeto.
  lifecycle {
    ignore_changes = [
      metadata,
    ]
  }
}



# Instalação do sigonz APM através do helm
resource "helm_release" "signoz" {

  depends_on = [
    kubernetes_namespace_v1.ns_signoz
  ]


  name       = "signoz"
  repository = "https://charts.signoz.io"
  chart      = "signoz"
  namespace  = local.observability_namespace_k8s
  version    = "0.74.3"

}

# # Criando o Ingress para publicação do frontend do signoz
# resource "kubectl_manifest" "ingress_signoz" {

#   depends_on = [
#     helm_release.signoz
#   ]

#   yaml_body = <<YAML
# apiVersion: networking.k8s.io/v1
# kind: Ingress
# metadata:
#   namespace: ${local.observability_namespace_k8s}
#   name: ingress-signoz-${var.environment}
#   annotations:
#     alb.ingress.kubernetes.io/scheme: internet-facing
#     alb.ingress.kubernetes.io/target-type: ip
# spec:
#   ingressClassName: alb
#   rules:
#     - http:
#         paths:
#         - path: /
#           pathType: Prefix
#           backend:
#             service:
#               name: signoz
#               port:
#                 number: 8080
# YAML
# }


# Instalação do opentelemetry no cluster EKS
resource "helm_release" "opentelemetry_eks" {

  depends_on = [
    helm_release.signoz
  ]


  name       = "k8s-infra"
  repository = "https://charts.signoz.io"
  chart      = "k8s-infra"
  namespace  = local.observability_namespace_k8s
  version    = "0.12.1"

  values = [
    file("./envs/${var.environment}/K8s-Infra-value.yaml")
  ]

}
