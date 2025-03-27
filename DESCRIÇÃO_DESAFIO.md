# Desafio AWS

A seguir está o detalhamento do desafio.


## Objetivo

O desafio tem o objetivo de construir uma stack de infraestrutura que provisione um ambiente capaz de rodar os seguintes componentes:

1. Duas aplicações (um backend e um frontend).
2. Um banco de dados.
3. Monitoramento das aplicações e do banco de dados.

Como deverá funcionar:

- **Aplicação 1 (Backend):** Uma API REST, que deve ser escalável automaticamente para lidar com aumentos de requisições.

- **Aplicação 2 (Frontend):** Um site com conteúdo estático que consome dados da API do backend. Deve ser capaz de lidar com variações bruscas de tráfego.

- **Banco de Dados:** O banco de dados deverá ser acessado por outro nome de DNS, mas estar no mesmo domínio das aplicações. O acesso ao banco será restrito exclusivamente às duas aplicações (backend e frontend).

- **Resolução de DNS:** Ambas as aplicações (frontend e backend) devem responder pelo mesmo DNS, mas em contextos distintos (paths diferentes, como `/frontend` e `/backend`).

- **Times distintos:** Cada aplicação terá um time responsável pelo seu ciclo de vida e manutenção. Esses times possuem pouco conhecimento em infraestrutura e cloud.

- **Time de monitoramento:** Existe um time responsável por acompanhar a qualidade e disponibilidade das aplicações. Este time não possui conhecimento técnico e precisa de dashboards com informações necessárias para acionar os times responsáveis quando necessário.

  
## Requisitos:

- Ambiente Cloud AWS

- Infraestrutura básica de rede (Firewall, VPC/SubNets, etc)

- Load Balancer

- Resolução de DNS

- Documentação detalhada

- Arquitetura da solução

- Instruções para execução em ambiente real (produção e desenvolvimento).

- Comparação/avaliação de custos em relação as diferentes possibilidades técnicas na criação deste ambiente.

## Tecnologias sugeridas:

- Terraform
- Cloud formation
- Python
- Container
- Kubernetes (Gerenciado ou não)
- Instancias de máquinas virtuais
- Serviços gerenciados de hospedagem de aplicações.
- Banco de dados Gerenciado ou não

**OBS:** outras ferramentas/soluções também são bem-vindas, desde que funcione de forma simples e eficiente.
  
## Será avaliado:

- Organização;
- Percentual de entrega;
- Criatividade;
- Roadmap de futuras melhorias;
- Qualidade da documentação;
- Uso de ferramentas de automatização;
- Elegância na solução proposta;
- Simplicidade e eficiência;
- Técnicas e boas práticas de segurança.


## Entrega:

O código deverá ser entregue em um repositório git hospedado na nuvem (ex: GitHub).

