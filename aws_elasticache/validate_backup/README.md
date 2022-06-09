# Validar o AWS Elasticache Backup

<!-- TOC -->

- [Validate AWS Elasticache Backup](#validate-aws-elasticache-backup)
- [About](#about)
- [Requirement](#requirement)
- [Running](#running)
- [Parameters Explanation](#parameters-explanation)
- [Addictional Instructions](#addictional-instructions)
- [License](#license)

<!-- TOC -->

# Sobre

Imagem Alpina com algumas ferramentas:

- awscli
- aws-iam-authenticator
- rdb
- and some basic packages:
- python3, py3-pip, curl, jq, bash, vim, net-tools, bind-tools and moreutils

# Requerimento

- AWS Elasticache Cluster
- Follow the AWS Documentation's instruction to create an Amazon Bucket S3 and grant permission to AWS ElastiCache access this bucket:
- https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/backups-exporting.html#backups-exporting-procedures
- For AWS Elasticache enable Automatic Backup and choose a Backup Retention Period and a Backup Window:
- https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/backups-automatic.html

# Executar

docker run -it --rm -e "AWS_ACCESS_KEY_ID=\<your_aws_access_key_id>" -e "AWS_SECRET_ACCESS_KEY=\<your_aws_secret_key>"" -e "AWS_DEFAULT_REGION=\<region>" -e "_DEBUG_COMMAND=<on|off>" -e "BACKUP_TIME=\<time>" -e "MY_S3_BUCKET=\<bucket_name>" -e "CACHE_SIZE=\<cache_size>" -e "REDIS_VERSION=\<redis_version>" -e "ZONE_01='<zone_01>'" -e "ZONE_02='<zone_02>'" -e "REPLICATION_GROUP_ID=\<replication_group_id>" -e "SLOT_01=\<slot_01>" -e "SLOT_02=\<slot_02>" -e "SLOT_03=\<slot_03>" -e "MINIMAL_KEYS_PERCENTAGE=\<keys_percentage>" --name sensedia sensedia/validate_backup_elasticache:1.0

```diferença
- Altere cada um dos parâmetros acima de acordo com seu ambiente antes de executar o comando docker run
```

# Explicação dos Parâmetros

AWS_ACCESS_KEY_ID - Seu ID da chave de acesso da AWS

AWS_SECRET_ACCESS_KEY - Sua chave secreta da AWS

AWS_DEFAULT_REGION - A região do cluster do AWS Elasticche

_DEBUG_COMMAND - Ativar (ativado) ou Desativar (desativado) a saída de depuração

BACKUP_TIME - Hora inicial da configuração da sua janela de backup (consulte [Requisito](#requirement))

MY_S3_BUCKET - Seu nome de bucket do S3 (consulte [Requisito](#requirement))

CACHE_SIZE - O tipo de nó, por exemplo: "cache.m5.large"

REDIS_VERSION - Versão do seu cluster do AWS Elasticche (compatibilidade de versão do mecanismo)

ZONE_01 e ZONE_02 - Zonas de disponibilidade da AWS, por exemplo: "us-east-1a" e "us-east-1c"

REPLICATION_GROUP_ID - Identificação do cluster, por exemplo: restore-backup-redis

SLOT_01, SLOT_02 e SLOT_03 - Slots/Keyspaces de Shards, por exemplo: 0-5461, 5462-10922 e 10923-16383

MINIMAL_KEYS_PERCENTAGE - Qual é o mínimo aceitável para chaves iguais desde o último instantâneo e estado real

# Instruções Adicionais

Se você tiver um número diferente de:

 - Nodes (3)
 - Regions (2)
 - Slots (3)

```diferença
- Você precisará alterar o script
```
