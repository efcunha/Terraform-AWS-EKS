# Cluster Kubernetes com Terraform e AWS-EKS
# Repositório com ferramentas, gráficos, scripts e compartilhado com a comunidade.

```bash
├── CONTRIBUTING.md
├── aws_elasticache # tools about aws elasticache
├── docker          # tools about docker
├── git             # tools about git
├── kubernetes      # tools about kubernetes (k8s)
├── LICENSE
├── prometheus # script and config about Prometheus
├── README.md
├── terraform  # code about Terraform
└── tutorials  # miscellaneous tutorials
```
# Introdução

Neste artigo iremos passar pelas boas práticas de como criar um cluster Kubernetes com Terraform e AWS-EKS, também conhecido por k8s (entenda o motivo aqui), utilizando o Terraform e o serviço EKS (Elastic Kubernetes Service) da AWS. Se você não sabe o que é Kubernetes, consulte o material Descomplicando o Kubernetes.

Se você não sabe o que é Terraform ou EKS, visite as seguintes páginas para obter mais informações:

http://blog.aeciopires.com/conhecendo-o-terraform

https://bit.ly/36iy82t

https://aws.amazon.com/eks.

Como uma forma de retribuir um pouco à comunidade de software livre, criei este repositório onde são publicados alguns scripts e ferramentas que utilizamos no dia a dia da operação de nossos serviços. 

Acreditamos que isso pode ajudar outras pessoas. 

Alguns dos comandos e código Terraform que vamos ver neste tutorial também estão publicados lá.

# Pré-requisitos

Neste tutorial será criado um cluster Kubernetes utilizando o EKS 1.17.x. Veja as novidades desta versão nos links a seguir:

https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html

https://kubernetes.io/blog/2019/12/09/kubernetes-1-17-release-announcement/

https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.17.md

Atenção: Em cada versão do Kubernetes e do EKS pode haver mudanças significativas na API (Application Programming Interface), tag e outras configurações que podem afetar a compatibilidade das aplicações, manifests, escalabilidade e balanceadores de carga. 

Então, é bem importante ler as notas da release e testar a nova versão em um ambiente diferente do de produção para se antecipar aos possíveis problemas e evitar indisponibilidade.

Para executar os passos deste tutorial você precisa utilizar alguma distribuição GNU/Linux, pois os comandos não foram testados no MS Windows ou MacOS.

É necessário ter uma conta de acesso à AWS e com as policies AdministratorAccess e PowerUserAccess associadas diretamente a sua conta ou associadas a uma role (grupo de policies) ao qual você possa utilizar. 

Essas policies contém todas as permissões necessárias para gerenciar recursos da AWS.

É necessário ter instalado o aws-cli versão 1.16.x ou superior. 

Também é necessário configurar as credenciais de acesso à API da AWS. Instale seguindo os passos deste tutorial:

https://github.com/efcunha/Terraform-AWS-EKS/blob/main/tutorials/install_awscli.md

É necessário ter instalado o kubectl versão 1.20.x ou superior. Se você não tem instalado, siga os passos deste tutorial:

https://github.com/efcunha/Terraform-AWS-EKS/blob/main/tutorials/install_kubectl.md

É necessário ter instalado o Terraform versão 0.12.x. Instale seguindo os passos deste tutorial:

https://github.com/efcunha/Terraform-AWS-EKS/blob/main/tutorials/install_terraform.md

Neste tutorial será criado uma rede VPC (Virtual Private Cloud) para uso no cluster Kubernetes e também será criado um bucket AWS-S3 e uma tabela no serviço AWS-DynamoDB para armazenarem o terraform state (informações do estado da infraestrutura a ser criada pelo Terraform).

# Entendendo o código

Baixe o código fonte com os seguinte comandos:

```bash
cd ~
git clone git@github.com:efcunha/Terraform-AWS-EKS.git
cd Terraform-AWS-EKS/terraform/eks
```

O diretório networking-eks contém o código necessário à criação da infraestrutura de rede requisito a criação do cluster EKS.

O nome de cada arquivo é bem intuitivo e o código dentro de cada um descreve a funcionalidade ou recursos a serem criados pelo Terraform. 

Exemplo: O arquivo vpc.tf, contém as instruções para gerenciar o recurso VPC e subnets da AWS. 

O arquivo policies.tf, cria as policies necessárias no serviço AWS-IAM.

O destaque fica por conta do arquivo testing.tfvars que contém os valores de alguns parâmetros importantes que podem ser customizados de acordo com a sua necessidade ou preferência. 

O arquivo outputs.tf contém o trecho de código que exibirá algumas informações sobre os recursos gerenciados pelo Terraform. 

Essas informações serão utilizadas para customizar o arquivo mycluster-eks/testing.tfvars.

O arquivo README.md contém as instruções e comandos a serem executados para criar a infraestrutura de rede.

Já o diretório mycluster-eks contém o código necessário à criação do cluster EKS.

O nome de cada arquivo também é intuitivo e o código dentro de cada um descreve a funcionalidade ou recursos a serem criados pelo Terraform. 

Exemplo: O arquivo eks.tf, contém as instruções para gerenciar o cluster.

O destaque também fica por conta do arquivo testing.tfvars e backend.tf que contém os valores de alguns parâmetros importantes que podem ser customizados de acordo com a sua necessidade.

O arquivo README.md contém as instruções e comandos a serem executados para criar o cluster.

Antes de executar os comandos da seção a seguir, abra cada arquivo e tente entender o que cada um faz. 

Consulte a documentação do Terraform e da AWS para entender melhor o que é cada recurso e para que serve.

Criando a VPC, o Bucket S3 e a tabela no DynamoDB

No arquivo Terraform-AWS-EKS/terraform/eks/networking-eks/testing.tfvars podemos ver o parâmetro region, que indica que a infraestrutura será criada na região Virginia (us-east-1), utilizando o profile default (que é o mesmo nome que está no arquivo ~/.aws/credentials e que deve conter a access key e secret key cadastradas para acessar a API da AWS).

Se não existir, crie um par de chaves assimétrico público-privada com o seguinte comando:
```bash
sudo ssh-keygen -t rsa -b 2048 -v -f /home/aws-testing.pem
```
Não informe uma senha durante a criação do par de chaves, apenas aperte ENTER. 

A chave pública será criada no seguinte caminho: /home/aws-testing.pem.pub e será cadastrada na AWS com o nome aws-testing. 

Essa chave pública será associada às instâncias EC2 durante a criação do cluster e dessa forma você poderá futuramente acessá-las via SSH utilizando a chave privada que está em /home/aws-testing.pem.

Estas informações foram cadastradas no arquivo Terraform-AWS-EKS/terraform/eks/networking-eks/testing.tfvars nos parâmetros aws_public_key_path e aws_key_name.

Outra informação importante a ser customizada neste mesmo arquivo é o parâmetro address_allowed, que contém o endereço IP público e máscara de rede que pode acessar a rede na qual será criado o cluster. 

Por padrão, o acesso externo é bloqueado.

O nome do bucket S3 que armazenará o terraform state está sendo definido no parâmetro bucket_name. 

O nome dos buckets na AWS é global e não pode haver outro bucket com o mesmo nome, mesmo em contas diferentes. 

É provável que você se depare com um erro durante a execução do Terraform dizendo que o bucket já existe e não será criado. 

A solução é definir outro nome. 

Esta informação será utilizada mais adiante para customizar a configuração do código que irá criar o cluster.

O nome da tabela no DynamoDB que será utilizado em conjunto com o bucket S3 serve para evitar que mais de uma pessoa altere o terraform state simultaneamente, está sendo definido no parâmetro dynamodb_table_name. 

Esta informação também será utilizada mais adiante para customizar a configuração do código que irá criar o cluster.

Crie a infraestrutura de rede (VPC, subnets, security group, route table, NAT Gateway, Internet Gateway), policies, bucket e tabela no DynamoDB com os seguintes comandos:
```bash
cd ~/Terraform-AWS-EKS/terraform/eks/networking-eks

terraform init

terraform validate

terraform workspace new testing

terraform workspace list

espaço de trabalho em terraformas selecione os testes

terraform plan -var-file testing.tfvars

terraform apply -var-file testing.tfvars
```
A criação da infraestrutura de rede pode demorar 5 minutos ou mais.

Visualize as informações da infraestrutura criada com os seguintes comandos:
```bash
terraform output
```
As seguintes informações serão utilizadas na seção seguinte para configurar alguns parâmetros no arquivo Terraform-AWS-EKS/terraform/eks/mycluster-eks/testing.tfvars
```bash
bucket_id

key_name

security_group

subnet_private1

subnet_public1

vpc1
```
# Criando o cluster EKS

Edite o arquivo Terraform-AWS-EKS/terraform/eks/mycluster-eks/backend.tf. 

Com base na informações utilizadas na seção anterior, altere os seguintes parâmetros:

bucket: informe o nome bucket criado anteriormente. Exemplo: “my-terraform-remote-state-01“;

dynamodb_table: informe o nome da tabela criada no DynamoDB. Exemplo: " my-terraform-state-lock-dynamo";

region: informe o nome da região AWS utilizada para criar o cluster, deve ser a mesma na qual foi criada a infraestrutura de rede. 

Exemplo: “us-east-1“;

profile: informe o nome do perfil AWS com as credenciais de acesso a API configuradas no arquivo ~/.aws/credentials. 

Deve ser o mesmo utilizado para criar a infraestrutura de rede. Exemplo: “default“.

Edite o arquivo Terraform-AWS-EKS/terraform/eks/mycluster-eks/testing.tfvars. 

Com base na informações utilizadas na seção anterior, altere os seguintes parâmetros:

profile: informe o nome do perfil AWS com as credenciais de acesso a API configuradas no arquivo ~/.aws/credentials. 

Deve ser o mesmo utilizado para criar a infraestrutura de rede. 

Exemplo: “default“.

region: informe o nome da região AWS utilizada para criar o cluster, deve ser a mesma na qual foi criada a infraestrutura de rede. 

Exemplo: “us-east-1“;

address_allowed: o endereço IP público e máscara de rede que pode acessar a rede na qual será criado o cluster. 

Exemplo: "“201.82.34.213/32”.

subnets: deve conter a lista com os IDs da subnet_private1 e subnet_public_1, mostrados no fim da seção anterior. 

Exemplo: ["subnet-06dd40e8124e67325", "subnet-098580d73a131193c"];

vpc_id: deve conter o ID da vpc1 mostrada no fim da seção anterior. 

Exemplo: "vpc-068004d30dd97a13b";

cluster_name: contém o nome do cluster. 

O nome informado aqui deve ser o mesmo no fim das tags “k8s.io/cluster-autoscaler/mycluster-eks-testing” e “kubernetes.io/cluster/mycluster-eks-testing”, do contrário não será possível habilitar o autoscaling do cluster. 

Exemplo: “mycluster-eks-testing”;

cluster_version: contém a versão do EKS a ser utilizada no cluster. 

Exemplo: “1.17”;

override_instance_types: lista com os tipos de instância EC2 a serem usados no cluster. 

Exemplo: ["t3.micro", "t3a.micro"];

on_demand_percentage_above_base_capacity: percentual de instâncias on demand a serem utilizadas no cluster. 

O percentual restante será de instâncias spot (mais baratas, porém efêmeras). 

Exemplo: 50;

asg_min_size: quantidade mínima de instâncias no cluster. 

Exemplo: 2;

asg_max_size: quantidade máxima de instâncias no cluster. 

Exemplo: 20;

asg_desired_capacity: quantidade deseja de instâncias no cluster. 

Exemplo: 2;

root_volume_size: tamanho em GB do disco a ser utilizado em cada instância. 

Exemplo: 20;

aws_key_name: nome da chave pública cadastrada na seção anterior a ser utilizada pelas instâncias EC2 do cluster. 

Exemplo: “aws-testing”;

worker_additional_security_group_ids: lista contendo o ID do security group criado na seção anterior que será associado ao cluster. 

Exemplo: ["sg-0bc21eaa5b3a26146"];

# Obtenha o ID de sua conta AWS com o seguinte comando:
```bash
aws sts get-caller-identity -query Account -output text -profile PROFILE_NAME_AWS
```
Onde:

PROFILE_NAME_AWS: é o nome do perfil AWS definido na configuração do arquivo ~/.aws/credentials

Edite novamente o arquivo Terraform-AWS-EKS/terraform/eks/mycluster-eks/testing.tfvars.

E altere todas as ocorrências do ID 255686512659 pelo ID da sua conta. 

Altere também a ocorrência da role adsoft pelo nome da role cadastrada na sua conta (se houver) e altere a ocorrência do usuário aeciopires pelo seu nome de usuário na AWS. 

Isto é muito importante porque os usuários e roles informados nos parâmetros map_roles e map_users serão os únicos admins do cluster EKS.

Finalmente, crie o cluster EKS com os seguintes comandos:
```bash
cd ~/Terraform-AWS-EKS/terraform/eks/mycluster-eks

terraform init

terraform validate

terraform workspace new testing

terraform workspace list

espaço de trabalho em terraformas selecione os testes

terraform plan -var-file testing.tfvars

terraform apply -var-file testing.tfvars
```
Obs: A criação do cluster pode demorar 15 minutos ou mais.

Visualize as informações do cluster criado com os seguintes comandos:
```bash
terraform output

terraform show
```

# Acessando o cluster EKS

Execute o seguinte comando para ter acesso ao cluster.
```bash
aws eks -region REGION_NAME update-kubeconfig -nome CLUSTER_NAME -profile PROFILE_NAME_AWS
```
Onde:

REGION_NAME: é o nome da região na qual o cluster foi criado.

CLUSTER_NAME: é o nome do cluster criado.

PROFILE_NAME_AWS: é o nome do perfil AWS definido na configuração do arquivo ~/.aws/credentials.

Exemplo:
```bash
aws eks -region us-east-1 update-kubeconfig -name mycluster -profile default
```
Para testar o acesso, visualize o status dos pods com o seguinte comando.
```bash
kubectl get pods –all-namespaces
```
# Troubleshooting no EKS

As informações sobre como fazer troubleshooting no EKS estão disponíveis nos links a seguir:

https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html

https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting_iam.html

https://aws.amazon.com/pt/premiumsupport/knowledge-center/eks-api-server-unauthorized-error

https://aws.amazon.com/premiumsupport/knowledge-center

Seção Amazon Elastic Container Service for Kubernetes (Amazon EKS)

# Visualizando o preço

As informações sobre o preço do uso do EKS, depende da região da AWS na qual o cluster está sendo criado, do tipo de instância EC2 que está sendo utilizado nos nodes workers, se está ou não utilizando instâncias spot, on-demand, se está utilizando instâncias reservadas, o tamanho e tipo do disco utilizado em cada nodes worker, se está sendo ou não utilizando uma VPC e NAT Gateway compartilhados com outros serviços, do data transfer entre as redes externas envolvidas, e ainda se está ou não utilizando algum Load Balancer da AWS para permitir o acesso externo às aplicações, o preço do Load Balancer também varia de acordo com o tipo, podendo ser: classic (ELB), application (ALB) ou network (NLB). 

Além disso a AWS cobra uma taxa de US$ 0.10 por hora para cada cluster EKS.

Obtenha mais informações sobre o preço do serviço AWS-EKS nos links a seguir:

https://aws.amazon.com/eks/pricing

https://aws.amazon.com/pt/ec2/pricing/on-demand

https://aws.amazon.com/eks/faqs

Para ajudar a obter uma estimativa de preço, a AWS fornece uma calculadora de preços: https://calculator.aws.

Veja um exemplo do custo mensal e anual da infraestrutura usada neste tutorial na região Virginia (us-east-1):

https://calculator.aws/#/estimate?id=de2c57ee696545b1fc9c6248533652724e208e5c

# Documentação

A documentação completa dos recursos utilizados neste tutorial estão disponíveis nos links a seguir. 

Utilize estas informações para aprofundar o aprendizado no dia a dia.

[Terraform:](https://www.terraform.io/docs)

[Provider-AWS:](https://www.terraform.io/docs/providers/aws)

[Módulo-Terraform-EKS:](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/13.0.0)

[AWS-VPC:](https://docs.aws.amazon.com/vpc/latest/userguide)

[AWS-S3:](https://docs.aws.amazon.com/AmazonS3/latest/gsg)

[AWS-DynamoDB:](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide)

[AWS-EKS:](https://docs.aws.amazon.com/eks/latest/userguide)

# Removendo o cluster EKS

Execute os seguintes comandos para remover o cluster EKS:
```bash
cd ~/Terraform-AWS-EKS/terraform/eks/mycluster-eks
```
espaço de trabalho em terraformas selecione os testes
```bash
terraformar destruir -var-file testing.tfvars
```
A remoção do cluster pode demorar 5 minutos ou mais.

# Removendo a VPC e os buckets S3

Execute os seguintes comandos para remover a infraestrutura de rede criada:
```bash
cd ~/Terraform-AWS-EKS/terraform/eks/networking-eks
```
espaço de trabalho em terraformas selecione os testes
```bash
terraformar destruir -var-file testing.tfvars
```
A remoção da infraestrutura de rede pode demorar 5 minutos ou mais.

Se ao final da remoção dos recursos, você visualizar o seguinte erro, acesse o console web da AWS e, em seguida, acesse a URL: 

https://s3.console.aws.amazon.com/s3/. 

Localize o nome do bucket e marque o checkbox ao lado esquerdo do nome. Em seguida, clique no botão empty. 

Siga as instruções para esvaziar o bucket.
```bash
Error: error deleting S3 Bucket …
```
BucketNotEmpty: The bucket you tried to delete is not empty. You must delete all versions in the bucket.

Depois disso, edite o arquivo Terraform-AWS-EKS/terraform/eks/networkin-eks/bucket.tf e altere o seguintes parâmetros:
```bash
Antes:
  versioning {
  enabled = true
}

lifecycle {
   prevent_destroy = true
}

Depois:

force_destroy = true
  versioning {
  enabled = false
}

lifecycle {
  prevent_destroy = false
}
```
Novamente execute os seguintes comandos para remover o bucket:
```bash
terraformar destruir -var-file testing.tfvars
```
Isto é necessário porque o bucket armazena o terraform state e em uma situação normal no ambiente de produção não é esperado que o bucket seja removido para evitar perder o rastreio das mudanças no ambiente usando o Terraform.

# Considerações finais

Neste tutorial aprendemos a criar um cluster kubernetes do zero utilizando o Terraform para gerenciar toda a infraestrutura de rede e o serviço AWS-EKS.

Nos próximos tutoriais apresentaremos o uso de outras tecnologias envolvendo o EKS para realizar o monitoramento de métricas, deploy e observabilidade de aplicações.
