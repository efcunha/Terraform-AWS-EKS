<!-- TOC -->

- [Instalar binário do Terraform](#Instalar-binário-do-Terraform)
- [Instale o tfenv para gerenciamento de versões do Terraform](#Instale-o-tfenv-para-gerenciamento-de-versões-do-Terraform)

<!-- TOC -->

## Instalar binário do Terraform

Execute os seguintes comandos para instalar o ``terraform``.

```bash
sudo su

TERRAFORM_ZIP_FILE=terraform_1.2.2_linux_amd64.zip
TERRAFORM_BASE_URL=https://releases.hashicorp.com/terraform/1.2.2

function install_terraform {
if [ -z $(which terraform) ]; then
    wget ${TERRAFORM_BASE_URL}/${TERRAFORM_ZIP_FILE}
    unzip ${TERRAFORM_ZIP_FILE}
    sudo mv terraform /usr/local/bin/terraform
    rm -rf ${TERRAFORM_ZIP_FILE}
    chmod +x /usr/local/bin/terraform
else
    echo "Terraform is most likely installed"
fi
}

install_terraform
which terraform
terraform version

exit
```

Mais informações sobre o ``terraform``: 

https://www.terraform.io/docs/index.html

## Instale o tfenv para gerenciamento de versões do Terraform

Execute os seguintes comandos para instalar o ``tfenv``.

```bash
cd $HOME
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
sudo ln -s ~/.tfenv/bin/* /usr/local/bin
```

Install Terraform version using ``tfenv`` command:

```bash
tfenv install 1.2.2
```

Mais informações sobre ``tfenv``:

https://github.com/tfutils/tfenv

Liste as versões do Terraform a serem instaladas:

```bash
tfenv list-remote
```

Usando a versão específica do Terraform instalada:

```bash
tfenv use <VERSION>
```

Desinstale a versão do Terraform com o comando ``tfenv``:

```bash
tfenv uninstall <VERSION>
```

Listar as versões do Terraform instaladas:

```bash
tfenv list
```

Somente ao desenvolver um código que faça uso do Terraform, você pode forçar o projeto a usar uma versão específica:

Crie o arquivo ``.terraform-version`` na raiz do projeto com o número da versão desejada. 

Exemplo:

```bash
echo "1.2.2" > .terraform-version
```
