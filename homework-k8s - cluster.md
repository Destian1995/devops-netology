# Домашнее задание к занятию «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.

Сервера разворачивал с помощью
 
[terraform](https://github.com/Destian1995/terraform-k8s/tree/main/terraform%20cluster)
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.
> На мастер-ноде: 
> Установка минимального набора ПО
```shell script
{
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl containerd
    sudo apt-mark hold kubelet kubeadm kubectl
}
```
> Включение ip-forward:
```shell script

modprobe br_netfilter 
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-arptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf

sysctl -p /etc/sysctl.conf
```
> 
> Инициализация ноды
```shell script
kubeadm init \
  --apiserver-advertise-address=10.0.0.27 \
  --pod-network-cidr 10.244.0.0/16 \
  --apiserver-cert-extra-sans=158.160.40.243
```
>По итогу получаем команду для подключения воркеров к ноде: 
``` shell script
kubeadm join 10.0.0.27:6443 --token gx9amz.zk20q3ythz55mji3 \
        --discovery-token-ca-cert-hash sha256:20a60c74ba3ab888479587c752f90c3610b1180f27fd364a4028e5a5649c84e5 
```


> На воркер-нодах: 
> Установка минимального набора ПО
```shell script
{
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl containerd
    sudo apt-mark hold kubelet kubeadm kubectl
}
```
> Включение ip-forward:
```shell script

modprobe br_netfilter 
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-arptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf

sysctl -p /etc/sysctl.conf
```
>По итогу получаем команду для подключения воркеров к ноде: 
``` shell script
kubeadm join 10.0.0.27:6443 --token gx9amz.zk20q3ythz55mji3 \
        --discovery-token-ca-cert-hash sha256:20a60c74ba3ab888479587c752f90c3610b1180f27fd364a4028e5a5649c84e5 
```
> Все поднялось, кластер заработал. Ноды друг-друга увидели. 



вывод kubectl get nodes:
```

```
## Дополнительные задания (со звёздочкой)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.** Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой необязательные к выполнению и не повлияют на получение зачёта по этому домашнему заданию. 

------
### Задание 2*. Установить HA кластер

1. Установить кластер в режиме HA.
2. Использовать нечётное количество Master-node.
3. Для cluster ip использовать keepalived или другой способ.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl get nodes`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
