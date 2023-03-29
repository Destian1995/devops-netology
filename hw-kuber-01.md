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
Вот далее затык...


``
Кратко: 
развернул на ВМ vagrant microk8s. Локально с самого хоста с дашбордом curl проходит успешно.
А вот удаленно подключится с клиента к хосту ВМ с дашбордом не удается.  по причине ERR_CONNECTION_TIMED_OUT либо ERR_CONNECTION_REFUSED
если пытаюсь использовать  https://localhost:10443
``
Вот полный скрипт отработки с момента входа в ВМ.
```
--скрипт установки microk8s и дашборда
sudo apt update
sudo apt install snapd
sudo snap install microk8s --classic
mkdir -p $HOME/.kube/
sudo usermod -a -G microk8s vagrant
sudo chown -f -R vagrant ~/.kube
newgrp microk8s
microk8s status
microk8s enable dashboard
microk8s kubectl config view --raw > $HOME/.kube/config
sudo microk8s refresh-certs --cert front-proxy-client.crt
TOKEN=$(microk8s kubectl -n kube-system get secret | awk '$1 ~ "default-token" {print $1}')
microk8s kubectl -n kube-system get secret $TOKEN -o jsonpath='{.data.token}' | base64 -d
microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443 --address='0.0.0.0'
```
Что я здесь упустил?






--
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
    token: ********TOKEN********

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
microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443
```
под разными вариантами затем пытался подключится с клиента
```
https://localhost:10443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
здесь натыкаюсь на 
ERR_CONNECTION_REFUSED

Пытался другой вариант указав сам IP ВМ

https://10.0.2.15:10443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

здесь натыкаюсь на
( ERR_CONNECTION_TIMED_OUT )
```

Пытался решить проблему с прокси(может в нем дело) 
потому что ранее всплывала такая ошибка
```
Unable to connect to the server: net/http: TLS handshake timeout
```
Gосле выполнения этих команд, ошибка выше исчезла, но к дашборду так и не смог подключится.
```
unset http_proxy
unset https_proxy
```

Пытался так же пройти путь заново по этой документации

https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

Удается подключится только непосредственно с самого хоста, а вот удаленно с другого клиента никак.

Пробрасывал еще порты в VirtualBox на конкретной машинке, но все тщетно.

Пытался установить Ubuntu как вторую подсистему, однако там нет systemd и в следствии этого образовалось ряд проблем которых не было на ВМ изначально.
Просто уже нет времени разбиратся еще и с systemd на локале.



