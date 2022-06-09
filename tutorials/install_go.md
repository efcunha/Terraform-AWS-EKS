<!-- TOC -->

- [Instalar Go](#instalar-go)

<!-- TOC -->

# Instalar Go

Execute os seguintes comandos para instalar o Go.

```bash
VERSION=1.18.3

mkdir -p $HOME/go/bin

cd /tmp
curl https://dl.google.com/go/go$VERSION.linux-amd64.tar.gz -o go.tar.gz

sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf go.tar.gz
rm /tmp/go.tar.gz

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

go version

echo "GOPATH=$HOME/go" >> ~/.bashrc
echo "PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin" >> ~/.bashrc
```

Mais informações: https://golang.org/doc
