# Desafio AWS

Este repositório será utilizado para armazenar os arquivos e documentações referentes ao desafio AWS.


## Objetivo do Projeto

Foi disponibilizada a descrição do desafio, presente no arquivo `desafio-aws/DESCRIÇÃO_DESAFIO.md`, onde o objetivo é construir uma stack de infraestrutura que provisione um ambiente capaz de rodar os componentes descritos no cenário relatado. Dessa forma, este projeto visa atender essa demanda explorando soluções e debater, tanto as tecnologias (usadas ou não), quanto os custos associados.




## Premissas do Projeto

- Testar as soluções propostas, mantendo o custo baixo
- Foco em segurança e boas práticas


## Visão Geral da Solução Proposta


Analisando a descrição do desafio, pensei inicialmente em utilizar a seguinte estrutura:

- Cloudfont para CDN
- S3 para o site estático
- Função Lambda para a API
- RDS para o banco de dados
- Cloudwatch para monitoramento e alertas

Com essa stack é possível atender a descrição, sendo escalável e mantendo o custo baixo. Porém, por se tratar de um Desafio sobre AWS, optei por fazer de forma a explorar as possíbilibilidades que a cloud da AWS pode proporcionar.

Assim, optei por fazer utilizando a seguinte estrutura:

- Cloudfont para CDN
- ALB na rede pública, para centralizar e direcionar o tráfego para a rede privada
- Containers para as aplicações
- EKS para a orquestração dos containers
- Signoz (Solução de APM opensource) para monitoramento e alertas.



## Estrutura do Projeto


Para a execução do projeto, foi criado um único repositório para hospedar todo o código. A seguir está a estrutura de arquivos e diretórios utilizado no projeto:

```bash
wander@bsnote283:~/desafio-aws$ tree
.
├── DESCRIÇÃO_DESAFIO.md
├── img
│   └── repository.drawio.png
├── infra
│   ├── alb.tf
│   ├── cdn.tf
│   ├── destroy_config.json
│   ├── ec2.tf
│   ├── eks.tf
│   ├── envs
│   │   ├── dev
│   │   │   ├── K8s-Infra-value.yaml
│   │   │   └── terraform.tfvars
│   │   └── prd
│   │       ├── K8s-Infra-value.yaml
│   │       └── terraform.tfvars
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── rds.tf
│   ├── route53.tf
│   ├── security-groups.tf
│   ├── signoz-helm.tf
│   ├── variables.tf
│   └── vpc.tf
├── README.md
└── src
    ├── docker-compose.yml
    ├── go-calculator
    │   ├── Dockerfile
    │   ├── go.mod
    │   ├── go.sum
    │   ├── k8s
    │   │   └── manifesto.yaml
    │   ├── main.go
    │   └── testes
    │       └── calculator.http
    ├── magic-calculator
    │   ├── app.py
    │   ├── Dockerfile
    │   ├── k8s
    │   │   └── manifesto.yaml
    │   ├── requirements.txt
    │   └── templates
    │       ├── error.html
    │       ├── index.html
    │       └── result.html
    └── README.md

12 directories, 38 files
wander@bsnote283:~/desafio-aws$ 


```

O projeto pode ser dividido basicamente em três partes: Pipelines (workflows), Infraestrutura e Aplicações. A seguir está a análise de cada item.

> **OBSERVAÇÃO:**
>
> - Os arquivos de Aplicação e Infraestrutura ficaram no mesmo repositório por conveniência. Em ambientes reais, principalmente se a infraestrutura não for exclusiva da aplicação em questão, é recomendado que estejam em repositórios separados.
>



Dessa forma, ele pode ser analisado em três partes: Pipelines, Infraestrutura e Aplicações.

- Repositório e Pipelines
    - visão geral
    - 

- Infraestrutura
    VPC
    CLOUDFRONT
    kubernetes
        autoscaller
- Aplicação
    - Frontend
    - API


## Repostiórios e Pipelines (Workflows)

Para hospedar o projeto, foi utilizado [este](https://github.com/wandermaia/desafio-aws) repositório do GitHub.

![repositorio](img/repository.drawio.png)




## Tecnologias Utilizadas

- AWS
    - Cloudfront
    - ELB
    - EKS
    - IAM
    - VPC
    - RDS
    - Route53
    - EC2
- Terraform
- Cloudfront
- Linguagens de programação/scripts Bash, Go e Python
- Container
- Docker
- Kubernetes
- Signoz

## Motivação para o uso de cada tecnologia




## Estrutura da Solução

Diagramas

Repositorio
fluxo terraform
vpc
cloudfront

## Instruções de Execução do Projeto


## Configurações



## Possíveis Evoluções do projeto



## Referências


Use IAM roles to connect GitHub Actions to actions in AWS

https://aws.amazon.com/pt/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/


Terraform Workspaces

https://developer.hashicorp.com/terraform/language/state/workspaces


AWS Provider

https://registry.terraform.io/providers/hashicorp/aws/latest/docs


AWS VPC Terraform module

https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest


AWS EKS Terraform module

https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest


Complete VPC Module parameters
https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/examples/complete/main.tf


cidrsubnet Function
https://developer.hashicorp.com/terraform/language/functions/cidrsubnet



Resource: aws_cloudfront_distribution
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution

Infracost

https://github.com/infracost/infracost



AWS RDS Terraform module
https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest

Complete example
https://github.com/terraform-aws-modules/terraform-aws-rds/blob/master/examples/complete-mysql/main.tf


Controle o tráfego para seus recursos da AWS usando grupos de segurança
https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/vpc-security-groups.html


Docker - Multi-stage builds
https://docs.docker.com/build/building/multi-stage/


Automate CloudFront updates when load balancer endpoints change by using Terraform
https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/automate-cloudfront-updates-when-load-balancer-endpoints-change.html