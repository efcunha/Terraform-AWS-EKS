# install_prometheus-operator_k8s

<!-- TOC -->

- [install_prometheus-operator_k8s](#install_prometheus-operator_k8s)
- [About](#about)
- [Summary](#summary)
- [Prerequisites for Prometheus Installation](#prerequisites-for-prometheus-installation)
- [Prometheus Installation](#prometheus-installation)
- [Troubleshooting](#troubleshooting)
- [Optional: Access Grafana](#optional-access-grafana)

<!-- TOC -->

# Sobre

Este repositório contém arquivos de configuração para implantar o Prometheus no cluster Kubernetes.

Usamos o Prometheus Operator para gerenciar as implantações nos clusters do kubernetes.

Mais informações sobre o operador prometheus podem ser encontradas nas páginas a seguir.

* https://github.com/coreos/prometheus-operator
* https://coreos.com/blog/the-prometheus-operator.html
* https://devops.college/prometheus-operator-how-to-monitor-an-external-service-3cb6ac8d5acb
* https://blog.sebastian-daschner.com/entries/prometheus-kubernetes-operator
* https://kruschecompany.com/kubernetes-prometheus-operator/
* https://containerjournal.com/topics/container-management/cluster-monitoring-with-prometheus-operator/
* https://sysdig.com/blog/kubernetes-monitoring-prometheus/
* https://sysdig.com/blog/kubernetes-monitoring-with-prometheus-alertmanager-grafana-pushgateway-part-2/
* https://sysdig.com/blog/kubernetes-monitoring-prometheus-operator-part3/

About config parameters of prometheu-operator:

* https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md
* https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#remotewritespec
* https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write
* https://www.robustperception.io/dropping-metrics-at-scrape-time-with-prometheus

# Resumo

A estrutura de diretórios é:

```bash
install_prometheus-operator_k8s/
├── deploy.sh # script for deploy prometheus-operator
├── es-index-size-exporter
│   └── es-index-size-exporter.py
├── helm_vars
│   ├── aws
│   │   ├── production
│   │   │   ├── some-k8s-cluster.yaml # values for a specific cluster deployment
|   |   |   └── values.yaml # common values for prod environment
|   │   ├── staging
|   │   │   ...
|   │   ├── testing
|   │   │   ...
|   │   ├── values.yaml # common values for AWS environment
|   ├── gcp
|   │   ├── production
|   │   │   ...
|   │   ├── staging
|   |   |   ...
|   |   ├── testing
|   |   |   ...
|   │   └── values.yaml # common values for GCP environment
│   ├── exporters
│   │   │   ├── some-exporter # directory with values for a specific exporter
|   |   |   └── values.yaml # common values for a specific exporter
│   │   │   ├── other-exporter # directory with values for a specific exporter
|   |   |   └── values.yaml # common values for a specific exporter
│   └── values.yaml # common values for all deployments
└── README.md # this documentation
```

# Pré-requisitos para instalação do Prometheus

* kubectl ~> 1.15 or major
* helm ~> v3.1.1 or major (see version supported https://helm.sh/docs/topics/version_skew/)
* gcloud
* sops -> 3.5.0 or major
* awscli -> 1.18 or major
* git

Install plugin Helm secrets.

```bash
helm plugin install https://github.com/jkroepke/helm-secrets --version v3.6.1
```

# Instalação do Prometheus

Crie ou acesse o cluster Kubernetes e configure o ``kubectl``.

Use o script `deploy.sh` neste repositório para instalar/atualizar uma versão do prometheus-operator.

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

cd install_prometheus-operator_k8s

./deploy.sh <install|upgrade> <aws|gcp> <testing|staging|production> <cluster_name> [--debug]
```

O argumento `<cluster_name>` deve ser o ``arquivo cluster.yaml`` que contém os valores a serem aplicados em uma implantação do operador prometheus.

O ``arquivo cluster.yaml`` deve ser criado em:

On AWS:

```bash
prometheus/
├── helm_vars/
│   ├── aws
│   │   ├── production
│   │   │   ├── file_cluster.yaml
```

On GCP:

```bash
prometheus/
├── helm_vars/
|   ├── gcp/
|   |   ├── production/
|   |   |   ├── file_cluster.yaml
```

Exemplos:

Implantação do Prometheus no cluster ``mycluster3`` no ambiente ``testing`` na AWS.

```bash
./deploy.sh install aws testing mycluster3
```

Implantação do Prometheus no cluster ``mycluster6`` no ambiente ``testing`` no GCP.

```bash
./deploy.sh install aws testing mycluster6
```

Para desinstalar o operador prometheus, execute o comando a seguir.

```bash
helm uninstall monitor -n monitoring
```

# Troubleshooting

Visualize o status do pod com o comando a seguir.

```bash
kubectl get pods -n monitoring
```

Visualize o log do Prometheus com o comando a seguir.

```bash
kubectl logs -f prometheus-monitor-mycompany-prometheus-0 -c prometheus -n monitoring
```

Comandos necessários para executar ou depurar diretamente qualquer conteúdo prometido para o pod ``prometheus-monitor-mycompany-prometheus-0`` no namespace ``monitoring`` de cada cluster Kubernetes.

```bash
kubectl exec -it prometheus-monitor-mycompany-prometheus-0 -n monitoring -- sh
```

Visualize o arquivo de configuração do Prometheus gerado pelo Prometheus-Operator.

```bash
cat /etc/prometheus/config_out/prometheus.env.yaml
```

Ver recursos de uso.

```bash
kubectl describe pod/prometheus-monitor-mycompany-prometheus-0 -n monitoring

kubectl top pods -n monitoring

kubectl top nodes -n monitoring
```

Mais informações sobre a solução de problemas no Prometheus-Operator estão disponíveis 

[nesta página](https://github.com/coreos/prometheus-operator/blob/master/Documentation/troubleshooting.md)

# Opcional: Acesso Grafana

Se deploy grafana estiver definido com o valor ``true`` no arquivo ``install_prometheus-operator_k8s/helm_vars/values.yaml``, use os comandos a seguir para acessar o Grafana:

```bash
kubectl get pods -n monitoring | grep grafana

kubectl port-forward POD_NAME 3000:3000 -n monitoring
```

Acesse seu navegador web na URL:

http://localhost:3000

* **login**: admin
* **password**: prom-operator

Para editar a senha padrão do Grafana, edite os segredos do Grafana do Operador Prometheus:

```bash
kubectl edit secrets monitor-grafana -n monitoring
```

Reference: https://dev.to/rayandasoriya/comment/dckk
