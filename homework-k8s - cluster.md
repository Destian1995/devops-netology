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

* Выбрал kubeadm
> На мастер-ноде: 
> Установка ПО
```shell script
{
    sudo apt-get update
    sudo add-apt-repository --remove "deb http://apt.kubernetes.io/ kubernetes-xenial main"
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
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
  --apiserver-advertise-address=10.0.1.12 \
  --pod-network-cidr 10.0.1.0/24 \
  --apiserver-cert-extra-sans=158.160.110.210
```
>По итогу получаем команду для подключения воркеров к ноде: 
``` shell script
kubeadm join 10.0.1.12:6443 --token ubfb0z.0lcvfxudara7bqxo \
        --discovery-token-ca-cert-hash sha256:36550fd1209383fa5f5a580bb77ebdb1a33093d63852149a39e1bad22843c192
```


> На воркер-нодах: 
> Установка ПО
```shell script
{
    sudo apt-get update
    sudo add-apt-repository --remove "deb http://apt.kubernetes.io/ kubernetes-xenial main"
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
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

> Все поднялось, кластер заработал. Ноды друг-друга увидели:
```
vagrant@vagrant:~/terraform-k8s/terraform cluster$ yc compute instance list
+----------------------+----------+---------------+---------+-----------------+-------------+
|          ID          |   NAME   |    ZONE ID    | STATUS  |   EXTERNAL IP   | INTERNAL IP |
+----------------------+----------+---------------+---------+-----------------+-------------+
| fhm6ih8b56efntsv89fs | worker-3 | ru-central1-a | RUNNING | 130.193.49.51   | 10.0.1.13   |
| fhm8bsabru45h7loh7dv | worker-1 | ru-central1-a | RUNNING | 158.160.105.75  | 10.0.1.16   |
| fhmic5s7k69a8g64nt8f | worker-0 | ru-central1-a | RUNNING | 158.160.56.11   | 10.0.1.31   |
| fhmrt0b5r2ig2qjvd2m9 | master   | ru-central1-a | RUNNING | 158.160.110.210 | 10.0.1.12   |
| fhms7iq7eaoqj5q0tatl | worker-2 | ru-central1-a | RUNNING | 158.160.106.188 | 10.0.1.34   |
+----------------------+----------+---------------+---------+-----------------+-------------+
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
