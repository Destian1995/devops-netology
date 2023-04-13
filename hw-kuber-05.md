# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к двум приложениям снаружи кластера по разным путям.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Service.
3. [Описание](https://kubernetes.io/docs/concepts/services-networking/ingress/) Ingress.
4. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
* [frontend](https://github.com/Destian1995/kuber-files-04/blob/main/deployment-front.yaml)
2. Создать Deployment приложения _backend_ из образа multitool. 
* [backend](https://github.com/Destian1995/kuber-files-04/blob/main/deployment-back.yaml)

3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера. 
4. Продемонстрировать, что приложения видят друг друга с помощью Service.
```
vagrant@vagrant:~/kuber-files-04$ k get deployment,pods,svc
NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/frontend-nginx      3/3     3            3           2m3s
deployment.apps/backend-multitool   1/1     1            1           99s

NAME                                     READY   STATUS    RESTARTS   AGE
pod/frontend-nginx-579c9dfc44-nvwtc      1/1     Running   0          111s
pod/frontend-nginx-579c9dfc44-jb5j9      1/1     Running   0          112s
pod/frontend-nginx-579c9dfc44-gk5f7      1/1     Running   0          111s
pod/backend-multitool-5fcd9f4d48-ld4fq   1/1     Running   0          95s

NAME                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/kubernetes              ClusterIP   10.152.183.1     <none>        443/TCP          6m52s
service/frontend-nginx-svc      NodePort    10.152.183.104   <none>        9001:30080/TCP   119s
service/backend-multitool-svc   NodePort    10.152.183.154   <none>        9002:30081/TCP   98s
vagrant@vagrant:~/kuber-files-04$
```

front
```
vagrant@vagrant:~/kuber-files-04$ kubectl exec frontend-nginx-579c9dfc44-nvwtc -- curl 10.152.183.154:9002
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0WBITT Network MultiTool (with NGINX) - 
backend-multitool-5fcd9f4d48-ld4fq - 10.1.52.140 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
100   152  100   152    0     0   1924      0 --:--:-- --:--:-- --:--:--  2000
vagrant@vagrant:~/kuber-files-04$
```
back
```
vagrant@vagrant:~/kuber-files-04$ kubectl exec backend-multitool-5fcd9f4d48-ld4fq -- curl 10.152.183.104:9001
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!DOCTYPE html>
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
100   615  100   615    0     0   2956      0 --:--:-- --:--:-- --:--:--  2971
vagrant@vagrant:~/kuber-files-04$
```
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.
* [Ingress](https://github.com/Destian1995/kuber-files-04/blob/main/ingress.yaml)

3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
```
curl nodes
```

4. Предоставить манифесты и скриншоты или вывод команды п.2.

------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
