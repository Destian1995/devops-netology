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


![2023-06-20_183622](https://github.com/Destian1995/devops-netology/assets/106807250/114f53b0-6211-4724-aba2-cc9f198a2dcf)

2. В качестве CRI — containerd.
```
ubuntu@fhmcbl3qndg3ht6vclou:~$ kubectl get nodes -o wide
NAME                   STATUS   ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
fhm3i41l1lokbsm6r928   Ready    <none>          4m30s   v1.27.3   10.0.1.24     <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.6.12
fhm4s6takouit25a5omg   Ready    <none>          3m42s   v1.27.3   10.0.1.6      <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.6.12
fhm702ekin4tj76sis5d   Ready    <none>          2m57s   v1.27.3   10.0.1.3      <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.6.12
fhmcbl3qndg3ht6vclou   Ready    control-plane   7m41s   v1.27.3   10.0.1.30     <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.6.12
fhmqercmrgg9kem4f6pu   Ready    <none>          2m17s   v1.27.3   10.0.1.27     <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.6.12
ubuntu@fhmcbl3qndg3ht6vclou:~$
```
3. Запуск etcd производить на мастере.
```
ubuntu@fhmcbl3qndg3ht6vclou:~$ kubectl get pods -A
NAMESPACE      NAME                                           READY   STATUS    RESTARTS   AGE
kube-flannel   kube-flannel-ds-d4khj                          1/1     Running   0          32s
kube-flannel   kube-flannel-ds-gkx65                          1/1     Running   0          72s
kube-flannel   kube-flannel-ds-kqznv                          1/1     Running   0          117s
kube-flannel   kube-flannel-ds-rztlj                          1/1     Running   0          2m45s
kube-flannel   kube-flannel-ds-w88gs                          1/1     Running   0          4m50s
kube-system    coredns-5d78c9869d-79fpz                       1/1     Running   0          5m39s
kube-system    coredns-5d78c9869d-wsgdz                       1/1     Running   0          5m39s
kube-system    etcd-fhmcbl3qndg3ht6vclou                      1/1     Running   0          5m54s
kube-system    kube-apiserver-fhmcbl3qndg3ht6vclou            1/1     Running   0          5m54s
kube-system    kube-controller-manager-fhmcbl3qndg3ht6vclou   1/1     Running   0          5m53s
kube-system    kube-proxy-46sm7                               1/1     Running   0          32s
kube-system    kube-proxy-6s9hc                               1/1     Running   0          72s
kube-system    kube-proxy-7lkj5                               1/1     Running   0          117s
kube-system    kube-proxy-hlfdf                               1/1     Running   0          5m39s
kube-system    kube-proxy-k97cs                               1/1     Running   0          2m45s
kube-system    kube-scheduler-fhmcbl3qndg3ht6vclou            1/1     Running   0          5m52s
ubuntu@fhmcbl3qndg3ht6vclou:~$
```
4. Способ установки выбрать самостоятельно.

* Выбрал kubeadm
* Далее идет последовательная установка для создания кластера после развертывания серверов.
> На мастер-ноде: 
> 1. Установка ПО
```shell script
{
sudo add-apt-repository --remove "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl containerd
sudo apt-mark hold kubelet kubeadm kubectl

modprobe br_netfilter 
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-arptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf

sysctl -p /etc/sysctl.conf
}
```
> 2. Далее инициализация ноды(выполняется только на мастере)
```shell script
kubeadm init \
  --apiserver-advertise-address=10.0.1.30 \
  --pod-network-cidr 10.224.0.0/16 \
  --apiserver-cert-extra-sans=62.84.118.175 
```
> По итогу получаем команду для подключения воркеров к ноде: 
``` shell script
sudo kubeadm join 10.0.1.30:6443 --token 9vhroy.vi2pvt1m7ukg8sxe \
         --discovery-token-ca-cert-hash sha256:9c73d69160e0a95112b546b488e9ec8859ee72edde9ea47670b83786a1083550
```


> 3. На каждой воркер-ноде: 
> Установка минимального ПО
```shell script
{
sudo add-apt-repository --remove "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl containerd
sudo apt-mark hold kubelet kubeadm kubectl

modprobe br_netfilter 
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-arptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf

sysctl -p /etc/sysctl.conf
}
```
> 4. Выполнение команды полученной в пункте 2 от мастер-сервера, на каждой ноде:
```
sudo kubeadm join 10.0.1.30:6443 --token 9vhroy.vi2pvt1m7ukg8sxe \
         --discovery-token-ca-cert-hash sha256:9c73d69160e0a95112b546b488e9ec8859ee72edde9ea47670b83786a1083550
```
Теперь мы связали все воркер ноды в один кластер и прекрепили их к мастер ноде.
Теперь можно приходить на мастер сервер и проверять кластер:
```
ubuntu@fhmcbl3qndg3ht6vclou:~$ kubectl get nodes -o wide
NAME                   STATUS   ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
fhm3i41l1lokbsm6r928   Ready    <none>          4m30s   v1.27.3   10.0.1.24     <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.6.12
fhm4s6takouit25a5omg   Ready    <none>          3m42s   v1.27.3   10.0.1.6      <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.6.12
fhm702ekin4tj76sis5d   Ready    <none>          2m57s   v1.27.3   10.0.1.3      <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.6.12
fhmcbl3qndg3ht6vclou   Ready    control-plane   7m41s   v1.27.3   10.0.1.30     <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.6.12
fhmqercmrgg9kem4f6pu   Ready    <none>          2m17s   v1.27.3   10.0.1.27     <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.6.12
ubuntu@fhmcbl3qndg3ht6vclou:~$
```
> Все поднялось, кластер заработал. Ноды друг-друга увидели:
```
vagrant@vagrant:~/terraform-k8s/terraform cluster$ yc compute instances list
+----------------------+----------+---------------+---------+----------------+-------------+
|          ID          |   NAME   |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+----------+---------------+---------+----------------+-------------+
| fhm3i41l1lokbsm6r928 | worker-3 | ru-central1-a | RUNNING | 158.160.114.11 | 10.0.1.24   |
| fhm4s6takouit25a5omg | worker-0 | ru-central1-a | RUNNING | 51.250.71.223  | 10.0.1.6    |
| fhm702ekin4tj76sis5d | worker-2 | ru-central1-a | RUNNING | 158.160.104.43 | 10.0.1.3    |
| fhmcbl3qndg3ht6vclou | master   | ru-central1-a | RUNNING | 62.84.118.175  | 10.0.1.30   |
| fhmqercmrgg9kem4f6pu | worker-1 | ru-central1-a | RUNNING | 130.193.39.127 | 10.0.1.27   |
+----------------------+----------+---------------+---------+----------------+-------------+
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
