# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к приложению, установленному в предыдущем ДЗ и состоящему из двух контейнеров, по разным портам в разные контейнеры как внутри кластера, так и снаружи.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Описание Service.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.

* [Deployment](https://github.com/Destian1995/kuber-files-05/blob/main/Deployment.yaml)
```
vagrant@vagrant:~/kuber-files-05$ k apply -f Deployment.yaml
deployment.apps/deployment-ntl-4 created
vagrant@vagrant:~/kuber-files-05$ k get pods
NAME                                READY   STATUS              RESTARTS   AGE
deployment-ntl-4-6b9685db56-b2w9g   0/2     ContainerCreating   0          36s
deployment-ntl-4-6b9685db56-59sds   0/2     ContainerCreating   0          37s
deployment-ntl-4-6b9685db56-n22vv   0/2     ContainerCreating   0          36s
vagrant@vagrant:~/kuber-files-05$ k get pods
NAME                                READY   STATUS    RESTARTS   AGE
deployment-ntl-4-6b9685db56-59sds   2/2     Running   0          2m35s
deployment-ntl-4-6b9685db56-b2w9g   2/2     Running   0          2m34s
deployment-ntl-4-6b9685db56-n22vv   2/2     Running   0          2m34s
```
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.

* [Service](https://github.com/Destian1995/kuber-files-05/blob/main/Service1.yaml)

3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.

* [Pod](https://github.com/Destian1995/kuber-files-05/blob/main/pod-multitool.yaml)

4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.
```
vagrant@vagrant:~/kuber-files-05$ kubectl exec -it multitool -- sh
/ # curl 10.152.183.154:9001
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
/ #
/ # curl 10.152.183.154:9002
WBITT Network MultiTool (with NGINX) - deployment-ntl-3-6b9685db56-n22vv - 10.1.52.133 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
/ #
```

5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
* [Service](https://github.com/Destian1995/kuber-files-05/blob/main/Service2.yaml)
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.

```
$ curl http://10.152.183.180:30080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

