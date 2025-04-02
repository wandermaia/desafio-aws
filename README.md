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

O projeto pode ser dividido basicamente em três partes:

- **Aplicações:** A pasta `src` contém o código das aplicações propriamente ditas.

- **Infraestrutura:** A pasta `infra` contem o código relacionado a criação da infraestrutura.

- **Workflows:** A pasta `.github/workflows` contém os códigos de definições dos workflows criadas.


> **OBSERVAÇÃO:**
>
> Os arquivos de Aplicação e Infraestrutura ficaram no mesmo repositório por conveniência. Em ambientes reais, principalmente se a infraestrutura não for exclusiva da aplicação em questão, é recomendado que estejam em repositórios separados.
>


Nos itens a seguir estão datalhados cada uma das três partes.


## Workflows (GitHub Actions)


Conforme mensionado anteriormente, foi criado um único repositório que será utilizado para armazenar todo o código. Neste repositório foram criadas duas branchs principais: a de develop, para o ambiente de desenvolvimento, e a branch main, para o ambiente de produção. 

Essas duas branchs serão utilizadas tanto para a Infraestrutura quanto para a homologação.

O fluxo de execução está representando no diagrama a seguir:

![repositorio](img/repository.drawio.png)


O Analista (dev ou infra) vai realizar o commit e um push para a branch de develop. Ao fazer isso, é acionada a trigger do GitHub Actions e a pipeline de homologação é executada, realizando o deploy de homologação da infra e/ou da aplicação.

Quando é realizado o Pull Request (PR) da branch de develop para a main, é acionado o trigger da pipeline de produção, realizando o deploy de produção da infra e/ou da aplicação.

> **OBSERVAÇÃO:**
>
> - O fluxo descrito acima é uma implementação de uma simples estratégia de branch. No ambiente produtivo podem ser implementadas outras estratégias, como por exemplo uma Feature Branch.
>

### Detalhamento dos Workflows

Neste projeto criamos oito workflows, cinco para as duas aplicações (frontend e api) e três para a infraestrutura. A seguir estão os arquivos de cada workflow na pasta `.github/workflows/`:


```bash
wander@bsnote283:~/desafio-aws$ tree .github/workflows/
.github/workflows/
├── api-dev-calculadora-api.yml
├── api-prd-calculadora-api.yml
├── ci-cd.yml
├── front-dev-magic-calculator.yml
├── front-prd-magic-calculator.yml
├── infra-dev.yml
├── infra-prd.yml
└── terraform.yml

0 directories, 8 files
wander@bsnote283:~/desafio-aws$ 

```

Para reaproveitar o código dos workflows, foi escolhida uma estratégia na qual temos dois workflows principais: `ci-cd.yml` (para aplicação) e `terraform.yml` (para infraestrutura).

O Workflow declarado no arquivo `ci-cd.yml` é responsável por executar o "trabalhao pesado" para os quatro workflows de aplicação (dev e prd da api, dev e prd do frontend), enquanto o arquivo `terraform.yml` segue a mesma ideia, executando o "trabalho pesado" para os dois workflows de infraestrutura (dev e prd).

### Triggers dos workflows

Como estamos utilizando apenas um repositório para a infraestrutura e para as duas aplicações (api e frontend), é necessário realizar uma definição nos workflows para que cada um seja disparado apenas quando fizer parte do contexto da alteração que estiver sendo realizada. A seguir está um detalhamento de como essa lógica está funcionando:


- **Workflow api-dev-calculadora-api** - Modificação da branch **develop** e alteração nos arquivos `"src/go-calculator/**"`. Passa os parâmetros e executa o worflow do arquivo `ci-cd.yml` para realizar o deploy de DEV.

- **Workflow api-prd-calculadora-api** - Modificação da branch **main** e alteração nos arquivos `"src/go-calculator/**"`. Passa os parâmetros e executa o worflow do arquivo `ci-cd.yml` para realizar o deploy de PRD.

- **Workflow front-dev-magic-calculator** - Modificação da branch **develop** e alteração nos arquivos `"src/magic-calculator/**"`. Passa os parâmetros e executa o worflow do arquivo `ci-cd.yml` para realizar o deploy de DEV.

- **Workflow front-prd-magic-calculator** - Modificação da branch **main** e alteração nos arquivos `"src/magic-calculator/**"`. Passa os parâmetros e executa o worflow do arquivo `ci-cd.yml` para realizar o deploy de PRD.

- **Workflow infra-dev** - Modificação da branch **develop** e alteração nos arquivos `"infra/**"`. Passa os parâmetros e executa o worflow do arquivo `terraform.yml` para realizar o deploy da infraestrutura pra DEV.

- **Workflow infra-prd** - Modificação da branch **main** e alteração nos arquivos `"infra/**"`. Passa os parâmetros e executa o worflow do arquivo `terraform.yml` para realizar o deploy da infraestrutura pra PRD.


A seguir está o código do worflow ``api-dev-calculadora-api.yml` (todos os demais seguem a mesma lógica) para facilitar o entendimento:


```yaml

name: "API - CALCULADORA DEV DEPLOY"

on:
  push:
    branches: ["develop"]
    paths: ["src/go-calculator/**"]
  workflow_dispatch:
    

# Permission can be added at job level or workflow level    
permissions:
      id-token: write   # This is required for requesting the JWT
      contents: read    # This is required for actions/checkout

jobs:
  CI-CD:
    uses: ./.github/workflows/ci-cd.yml
    secrets:
      dockerhub-username: ${{ secrets.DOCKERHUB_USERNAME }}
      dockerhub-token: ${{ secrets.DOCKERHUB_TOKEN }}
      aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
      aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      db-user: ${{ secrets.DB_USER }}
      db-password: ${{ secrets.DB_PASSWORD }}
    with:
      aws-region: "us-east-1"
      environment: "dev"
      app-name: "calculadora-api"
      app-path: "src/go-calculator"
      app-namespace-kubernetes: "calculator"

```

### Integração GitHub Actions com AWS




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