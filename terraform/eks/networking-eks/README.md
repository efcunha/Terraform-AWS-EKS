<!-- TOC -->

- [Sobre](#sobre)
- [Requisitos](#requisitos)
   - [Como](#como)
   - [Requisitos](#requisitos-1)
   - [Provedores](#provedores)
   - [Entradas](#entradas)
   - [Saídas](#saídas)

<!-- TOC -->
# Sobre

1. Este diretório contém os arquivos:<br>
   * ``variables.tf`` => onde você pode definir os valores das variáveis usadas por ``main.tf``.<br>
   * ``testing.tfvars`` => onde você pode definir os valores das variáveis usadas no ambiente de teste.<br>
2. O objetivo é criar a rede exigida pelo cluster EKS na AWS.

# Requisitos

=====================

NOTA: Desenvolvido usando a sintaxe do Terraform 0.12.x.

=====================

* Configure as credenciais da AWS e instale o [kubectl](../../../tutorials/install_kubectl.md), [aws-cli](../../../tutorials/install_awscli.md), [terraform](../../../tutorials/install_terraform.md).

* Crie os seguintes recursos necessários para o funcionamento do cluster EKS:
  * Bucket S3 and DynamoDB table for Terraform state remote;
  * Subnets public and private;
  * VPC;
  * NAT gateway;
  * Internet Gateway;
  * Security group;
  * Route table;
  * Policies.

* Execute os comandos:

```bash
cd ~/Terraform-AWS-EKS/terraform/eks/networking-eks
```

## Como

* Altere os valores de acordo com a necessidade do ambiente nos arquivos ``testing.tfvars`` e ``backend.tf``.

* Valide as configurações e crie o ambiente com os seguintes comandos:

```bash
terraform init
terraform validate
terraform workspace new testing
terraform workspace list
terraform workspace select testing
terraform plan -var-file testing.tfvars
terraform apply -var-file testing.tfvars
terraform output
terraform show
```

Comandos úteis:

* ``terraform --help``   => Mostrar ajuda do comando terraform<br>
* ``terraform init``     => Inicialize um diretório de trabalho do Terraform<br>
* ``terraform validate`` => Valida os arquivos do Terraform<br>
* ``terraform plan``     => Gerar e mostrar um plano de execução<br>
* ``terraform apply``    => Constrói ou altera a infraestrutura<br>
* ``terraform output``   => Lê uma variável de saída de um arquivo de estado do Terraform e imprime o valor.<br>
* ``terraform show``     => Inspecione o estado ou plano do Terraform<br>

## Requisitos

| Name | Version |
|------|---------|
| terraform | >= 0.12.19, < 0.13.0 |
| aws | >= 2.61.0 |
| local | >= 1.4.0 |
| null | >= 2.1.2 |
| random | >= 2.2.1 |
| template | >= 2.1.2 |

## Provedores

| Name | Version |
|------|---------|
| aws | >= 2.61.0 |
| local | >= 1.4.0 |

## Entradas

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_allowed | IP or Net address allowed for remote access. | `any` | n/a | yes |
| aws\_key\_name | Key pair RSA name. | `any` | n/a | yes |
| aws\_public\_key\_path | PATH to public key in filesystem local. | `any` | n/a | yes |
| bucket\_name | Bucket name for storage Terraform tfstate remote. | `any` | n/a | yes |
| credentials\_file | PATH to credentials file | `string` | `"~/.aws/credentials"` | no |
| dynamodb\_table\_name | DynamoDB Table name for lock Terraform tfstate remote. | `any` | n/a | yes |
| environment | Name Terraform workspace. | `any` | n/a | yes |
| profile | Profile of AWS credential. | `any` | n/a | yes |
| region | AWS region. Reference: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions | `any` | n/a | yes |
| subnet\_private1\_cidr\_block | CIDR block to subnet private1. | `any` | n/a | yes |
| subnet\_public1\_cidr\_block | CIDR block to subnet public1. | `any` | n/a | yes |
| tags | Maps of tags. | `map` | `{}` | no |
| vpc1\_cidr\_block | CIDR block to vpc1. | `any` | n/a | yes |

## Saídas

| Name | Description |
|------|-------------|
| bucket\_arn | Bucket ARN |
| bucket\_domain\_name | FQDN of bucket |
| bucket\_id | Bucket Name (aka ID) |
| key\_name | Name of key pair RSA |
| security\_group | Id of security Group |
| subnet\_private1 | Id of subnet private 1 |
| subnet\_public1 | Id of subnet public 1 |
| vpc1 | Id of VPC1 |
