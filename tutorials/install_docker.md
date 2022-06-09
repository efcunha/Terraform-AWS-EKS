<!-- TOC -->

- [Instalar o Docker](#instalar-o-docker)

<!-- TOC -->

# Instalar o Docker

Instale o Docker CE (Community Edition) seguindo as instruções das páginas abaixo, de acordo com sua distribuição GNU/Linux.

* CentOS: https://docs.docker.com/install/linux/docker-ce/centos/
* Debian: https://docs.docker.com/install/linux/docker-ce/debian/
* Ubuntu: https://docs.docker.com/install/linux/docker-ce/ubuntu/

Inicie o serviço ``docker``, configure o Docker para inicializar com o SO e adicione seu usuário ao grupo ``docker``.

```bash
#Inicia o serviço Docker
sudo systemctl start docker

# Configure o Docker para inicializar com o SO
sudo systemctl habilitar docker

# Adicione seu usuário ao grupo Docker
sudo usermod -aG docker $USER
sudo setfacl -m user:$USER:rw /var/run/docker.sock
```

Referência: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot
