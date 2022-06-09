<!-- TOC -->

- [Instalar AWC-CLI](#instalar-awc-cli)
- [Configurar credenciais da AWS](#configurar-credenciais-da-aws)

<!-- TOC -->

# Instalar AWC-CLI

Execute os seguintes comandos para instalar o pacote ``awscli``.

```bash
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"

descompacte awscli-bundle.zip

sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

aws --versão

rm -rf awscli-bundle.zip awscli-bundle
```

Mais informações sobre ``aws-cli``: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html

Referência: https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html

# Configurar credenciais da AWS

[OPCIONAL] Você precisará criar uma conta Amazon AWS. Crie uma conta de **Nível gratuito** na Amazon https://aws.amazon.com/ siga as instruções nas páginas: 

https://docs.aws.amazon.com/chime/latest/ag/aws-account. 

e 

https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html. 

Ao criar a conta, você precisará cadastrar um cartão de crédito, mas como você criará instâncias usando os recursos oferecidos pelo plano **Nível Gratuito**, nada será cobrado se você não ultrapassar o limite de uso dos recursos e tempo oferecido e descrito no link anterior.

Após criar a conta na AWS, acesse a interface da Amazon CLI em: https://aws.amazon.com/cli/

Clique no nome de usuário (canto superior direito) e escolha a opção **Security Credentials**. 

Em seguida, clique na opção **Access Key and Secret Access Key** e clique no botão **New Access Key** para criar e visualizar o ID e o segredo da chave.

Crie o diretório abaixo.

```bash
echo $HOME

mkdir -p $HOME/.aws/

toque em $HOME/.aws/credentials
```

Abra o arquivo ``$HOME/.aws/credentials`` e adicione o seguinte conteúdo e altere a chave de acesso e a chave de acesso secreta.
```
[predefinição]
aws_access_key_id = YOUR_ACCESS_KEY_HERE
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY_HERE
```

Nesse caso, o nome do perfil AWS é **padrão**.

Referências: https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html
