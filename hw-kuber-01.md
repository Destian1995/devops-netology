# Домашнее задание к занятию «Kubernetes. Причины появления. Команда kubectl»

### Цель задания

Для экспериментов и валидации ваших решений вам нужно подготовить тестовую среду для работы с Kubernetes. Оптимальное решение — развернуть на рабочей машине или на отдельной виртуальной машине MicroK8S.

------

### Чеклист готовности к домашнему заданию

1. Личный компьютер с ОС Linux или MacOS 

или

2. ВМ c ОС Linux в облаке либо ВМ на локальной машине для установки MicroK8S  

------

### Инструкция к заданию

1. Установка MicroK8S:
    - sudo apt update,
    - sudo apt install snapd,
    - sudo snap install microk8s --classic,
    - добавить локального пользователя в группу `sudo usermod -a -G microk8s $USER`,
    - изменить права на папку с конфигурацией `sudo chown -f -R $USER ~/.kube`.

2. Полезные команды:
    - проверить статус `microk8s status --wait-ready`;
    - подключиться к microK8s и получить информацию можно через команду `microk8s command`, например, `microk8s kubectl get nodes`;
    - включить addon можно через команду `microk8s enable`; 
    - список addon `microk8s status`;
    - вывод конфигурации `microk8s config`;
    - проброс порта для подключения локально `microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443`.

3. Настройка внешнего подключения:
    - отредактировать файл /var/snap/microk8s/current/certs/csr.conf.template
    ```shell
    # [ alt_names ]
    # Add
    # IP.4 = 123.45.67.89
    ```
    - обновить сертификаты `sudo microk8s refresh-certs --cert front-proxy-client.crt`.

4. Установка kubectl:
    - curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl;
    - chmod +x ./kubectl;
    - sudo mv ./kubectl /usr/local/bin/kubectl;
    - настройка автодополнения в текущую сессию `bash source <(kubectl completion bash)`;
    - добавление автодополнения в командную оболочку bash `echo "source <(kubectl completion bash)" >> ~/.bashrc`.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Инструкция](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/#bash) по установке автодополнения **kubectl**.
3. [Шпаргалка](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/) по **kubectl**.

------

### Задание 1. Установка MicroK8S

1. Установить MicroK8S на локальную машину или на удалённую виртуальную машину.
2. Установить dashboard.
3. Сгенерировать сертификат для подключения к внешнему ip-адресу.

------

### Задание 2. Установка и настройка локального kubectl
1. Установить на локальную машину kubectl.
2. Настроить локально подключение к кластеру.
3. Подключиться к дашборду с помощью port-forward.

------
### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода команд `kubectl get nodes` и скриншот дашборда.

```
vagrant@vagrant:~$ kubectl get nodes
NAME      STATUS   ROLES    AGE   VERSION
vagrant   Ready    <none>   17h   v1.26.1
```

На сайт дашборда никак не удается зайти.
Кратко: развернул на ВМ vagrant. microk8s. Но с самого компьютера подключится к сайту дашборда который развернут на ВМ.


Развернул я все на ВМ ubuntu 20.04 на своем же компьютере. 
Установку ввел как и по инструкции выше в этом файле, так и по другим(было подозрение что microk8s не правильно встал)
Благодря этим туториалам решилась проблема 
```
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```
https://gitlab.com/xavki/tutoriels-microk8s/-/blob/master/01-installation-manuelle/slides.md
https://gitlab.com/xavki/tutoriels-microk8s/-/blob/master/02-extension-dashboard/slides.md

Собственно сам config view
```
vagrant@vagrant:~$ microk8s config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ********TOKEN********
    server: https://10.0.2.15:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
current-context: microk8s
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: YzBkNzlIUzgyek5jU092aEQvMEV6UVc2THVScGYweVlqUWlaWkxpcTNhZz0K

vagrant@vagrant:~$
```

Сам microk8s стоит и дашборд включен.
```
vagrant@vagrant:~$ microk8s status
microk8s is running
high-availability: no
  datastore master nodes: 127.0.0.1:19001
  datastore standby nodes: none
addons:
  enabled:
    dashboard            # (core) The Kubernetes dashboard
    ha-cluster           # (core) Configure high availability on the current node
    helm                 # (core) Helm - the package manager for Kubernetes
    helm3                # (core) Helm 3 - the package manager for Kubernetes
    metrics-server       # (core) K8s Metrics Server for API access to service metrics
```
Вот конфиг для внешнего подключения, юзал разные варианты.
```
vagrant@vagrant:~$ cat /var/snap/microk8s/current/certs/csr.conf.template
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = GB
ST = Canonical
L = Canonical
O = Canonical
OU = Canonical
CN = 127.0.0.1

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster
DNS.5 = kubernetes.default.svc.cluster.local
IP.1 = 127.0.0.1
IP.2 = 10.152.183.1
IP.4 = 10.0.2.15 - IP самой ВМ
#IP.4 = 10.152.183.137 - IP дашборда
#MOREIPS

[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment,digitalSignature
extendedKeyUsage=serverAuth,clientAuth
subjectAltName=@alt_names
vagrant@vagrant:~$
```
сертификаты обновил.
Так же проверял не упал ли сервис
```
vagrant@vagrant:~$ microk8s kubectl get pods -n kube-system
NAME                                        READY   STATUS    RESTARTS         AGE
dashboard-metrics-scraper-7bc864c59-mnm2r   1/1     Running   4 (4h6m ago)     17h
calico-node-xldpd                           1/1     Running   4 (4h6m ago)     17h
calico-kube-controllers-6ff578f9bd-ljqvs    1/1     Running   4 (4h6m ago)     17h
kubernetes-dashboard-dc96f9fc-hs7qc         1/1     Running   11 (4m21s ago)   17h
metrics-server-6f754f88d-dgtsk              1/1     Running   22 (3m55s ago)   17h
vagrant@vagrant:~$
```
Добавлял правило для фаервола
```
sudo ufw allow 8001/tcp
```
После чего пытался запустить Дашборд
```
microk8s kubectl proxy --address 0.0.0.0 --accept-hosts '.*'
```
под разными вариантами
```
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
```
Здесь перед заходом естественно менял IP подключения на соответствующий.
```
http://10.0.2.15:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
```
Но при попытке попасть выдавало 
( ERR_CONNECTION_TIMED_OUT )
Тоже самое если использовал другую команду
```
microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443 --address='0.0.0.0'
```


Пытался решить проблему с прокси(может в нем дело) потому что ранее всплывала такая ошибка
```
Unable to connect to the server: net/http: TLS handshake timeout
```
Но после выполнения этих команд, все стало нормально.
```
unset http_proxy
unset https_proxy
```

Пытался так же пройти путь заново по этой документации

https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

Но после ввода команды kubectl proxy на сайт зайти не удалось по той же причине.

( ERR_CONNECTION_TIMED_OUT )

Пытался установить Ubuntu как вторую подсистему, однако там нет systemd и в следствии этого образовалось ряд проблем которых не было на ВМ изначально.
Просто уже нет времени разбиратся еще и с systemd на локале.



