<!-- TOC -->

- [Sobre](#sobre)
- [Requisitos](#requisitos)
- [Como](#como)
- [Soluções](#soluções)
- [Requisitos](#requisitos-1)
- [Provedores](#provedores)
- [Entradas](#entradas)
- [Saídas](#saídas)

<!-- TOC -->
# Sobre

1. Este diretório contém os arquivos:<br>
   * ``variables.tf`` => onde você pode definir os valores das variáveis usadas por ``main.tf``.<br>
   * ``testing.tf`` => onde você pode definir os valores das variáveis usadas no ambiente de teste.<br>
2. O objetivo é criar um cluster EKS na AWS.

# Requisitos

=====================

NOTA: Desenvolvido usando a sintaxe do Terraform 0.12.x.

=====================

* Configure as credenciais da AWS e instale o [kubectl](../../../tutorials/install_kubectl.md), [aws-cli](../../../tutorials/install_awscli.md), [terraform](../../../tutorials/install_terraform.md).

* Crie os seguintes recursos necessários para o funcionamento do cluster EKS. Faça isso executando o código do Terraform conforme instruído no arquivo [../networking-eks/README.md](../networking-eks/README.md). 

* Veja a saída do ``terraform apply`` e altere os valores das sub-redes, vpc, security group nos arquivos [testing.tfvars](testing.tfvars) e [backend.tf](backend.tf) conforme às necessidades do seu ambiente.

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
cd ~/Terraform-AWS-EKS/terraform/eks/mycluster-eks
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

* ``terraform --help`` => Mostrar ajuda do comando terraform<br>
* ``terraform init`` => Inicialize um diretório de trabalho do Terraform<br>
* ``terraform validate`` => Valida os arquivos do Terraform<br>
* ``terraform plan`` => Gerar e mostrar um plano de execução<br>
* ``terraform apply`` => Constrói ou altera a infraestrutura<br>
* ``terraform output`` => Lê uma variável de saída de um arquivo de estado do Terraform e imprime o valor.<br>
* ``terraform show`` => Inspecione o estado ou plano do Terraform>

Acesse o cluster com Kubectl.

```bash
aws eks --region REGION_NAME update-kubeconfig --name CLUSTER_NAME --profile PROFILE_NAME_AWS

kubectl get nodes -A

kubectl get pods -A
```

# Soluções

Documentações:

* https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html
* https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/
* https://github.com/kubernetes/kubernetes/issues/75457
* https://github.com/aws/containers-roadmap/issues/607
* https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html
* https://aws.amazon.com/pt/premiumsupport/knowledge-center/eks-cluster-autoscaler-setup/
* https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
* https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/faq.md
* https://github.com/terraform-aws-modules/terraform-aws-eks
* https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples

## Requisitos

| Name | Version |
|------|---------|
| terraform | >= 0.12.19, < 0.13.0 |
| aws | >= 3.22.0 |
| kubernetes | >= 1.11.2 |
| local | >= 1.4.0 |
| null | >= 2.1.2 |
| random | >= 2.2.1 |
| template | >= 2.1.2 |

## Provedores

| Name | Version |
|------|---------|
| aws | >= 3.22.0 |
| local | >= 1.4.0 |
| null | >= 2.1.2 |
| template | >= 2.1.2 |

## Entradas

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_allowed | IP or Net address allowed for remote access. | `any` | n/a | yes |
| asg\_desired\_capacity | Number desired of nodes workers in cluster EKS. | `number` | n/a | yes |
| asg\_max\_size | Number maximal of nodes workers in cluster EKS. | `number` | n/a | yes |
| asg\_min\_size | Number minimal of nodes workers in cluster EKS. | `number` | n/a | yes |
| autoscaling\_enabled | Enable ou disable autoscaling. | `bool` | `true` | no |
| aws\_key\_name | Key pair RSA name. | `any` | n/a | yes |
| cluster\_enabled\_log\_types | A list of the desired control plane logging to enable.<br> For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html) | `list(string)` | <pre>[<br>  "api",<br>  "audit"<br>]</pre> | no |
| cluster\_endpoint\_private\_access | Indicates whether or not the Amazon EKS private API server endpoint is enabled. | `bool` | `true` | no |
| cluster\_endpoint\_private\_access\_cidrs | List of CIDR blocks which can access the Amazon EKS private API server endpoint, when public access is disabled | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| cluster\_endpoint\_public\_access | Indicates whether or not the Amazon EKS public API server endpoint is enabled. | `bool` | `true` | no |
| cluster\_endpoint\_public\_access\_cidrs | List of CIDR blocks which can access the Amazon EKS public API server endpoint. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| cluster\_log\_retention\_in\_days | Number of days to retain log events. | `number` | `"7"` | no |
| cluster\_name | Cluster EKS name. | `any` | n/a | yes |
| cluster\_version | Kubernetes version supported by EKS. <br> Reference: https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html | `any` | n/a | yes |
| credentials\_file | PATH to credentials file | `string` | `"~/.aws/credentials"` | no |
| cw\_retention\_in\_days | Fluentd retention in days. | `number` | `7` | no |
| environment | Name Terraform workspace. | `any` | n/a | yes |
| kubelet\_extra\_args | Extra arguments for EKS. | `string` | `"--node-labels=node.kubernetes.io/lifecycle=spot"` | no |
| lt\_name | Name of template worker group. | `any` | n/a | yes |
| map\_roles | Additional IAM roles to add to the aws-auth configmap.<br> See https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/basic/variables.tf for example format. | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| map\_users | Additional IAM users to add to the aws-auth configmap.<br> See https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/basic/variables.tf for example format. | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| on\_demand\_percentage\_above\_base\_capacity | On demand percentage above base capacity. | `number` | n/a | yes |
| override\_instance\_types | Type instances for nodes workers. Reference: https://aws.amazon.com/ec2/pricing/on-demand/ | `list(string)` | n/a | yes |
| profile | Profile of AWS credential. | `any` | n/a | yes |
| public\_ip | Enable ou disable public IP in cluster EKS. | `bool` | `false` | no |
| region | AWS region. Reference: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions | `any` | n/a | yes |
| root\_volume\_size | Size of disk in nodes of cluster EKS. | `number` | n/a | yes |
| subnets | List of IDs subnets public and/or private. | `list(string)` | n/a | yes |
| suspended\_processes | Cluster EKS name. | `any` | n/a | yes |
| tags | Maps of tags. | `map` | `{}` | no |
| vpc\_id | ID of VPC. | `any` | n/a | yes |
| worker\_additional\_security\_group\_ids | A list of additional security group ids to attach to worker instances. | `list(string)` | `[]` | no |
| workers\_additional\_policies | Additional policies to be added to workers | `list(string)` | `[]` | no |

## Saídas

| Name | Description |
|------|-------------|
| cluster\_endpoint | Endpoint for EKS control plane. |
| cluster\_security\_group\_id | Security group ids attached to the cluster control plane. |
| config\_map\_aws\_auth | A kubernetes configuration to authenticate to this EKS cluster. |
| kubectl\_config | kubectl config as generated by the module. |
| region | AWS region. |
