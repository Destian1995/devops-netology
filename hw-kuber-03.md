# Домашнее задание к занятию «Запуск приложений в K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.

* [my-app.yaml](https://github.com/Destian1995/kuber-files-03/blob/main/my-app.yaml)
```
vagrant@vagrant:~/kuber-files-03$ kubectl apply -f my-app.yaml
deployment.apps/my-app created
```
2. После запуска увеличить количество реплик работающего приложения до 2.
3. Продемонстрировать количество подов до и после масштабирования.

*до
```
vagrant@vagrant:~/kuber-files-03$ k get pods
NAME                        READY   STATUS    RESTARTS   AGE
my-app-67d455fc57-r9m2b     2/2     Running   0          7m53s
```
*масштабируем
```
vagrant@vagrant:~/kuber-files-03$ kubectl scale deployment my-app --replicas=2
deployment.apps/my-app scaled

```
*после
```
vagrant@vagrant:~/kuber-files-03$ k get pods
NAME                        READY   STATUS    RESTARTS   AGE
my-app-67d455fc57-r9m2b     2/2     Running   0          10m
my-app-67d455fc57-925wh     2/2     Running   0          91s
```
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.

* [Service](https://github.com/Destian1995/kuber-files-03/blob/main/Service.yaml)
```
vagrant@vagrant:~/kuber-files-03$ k apply -f Service.yaml
service/my-app-service created
```
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.
```
vagrant@vagrant:~/kuber-files-03$ kubectl run multitool --image=wbitt/network-multitool --restart=Never
vagrant@vagrant:~/kuber-files-03$ kubectl exec -it multitool -- curl my-app-service
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
vagrant@vagrant:~/kuber-files-03$
```
------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.

* [ngnix-deploymanet](https://github.com/Destian1995/kuber-files-03/blob/main/nginx.yaml)

```
vagrant@vagrant:~/kuber-files-03$ k apply -f nginx.yaml
deployment.apps/nginx-deployment created
```

2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.

```
После применения манифеста можно проверить, что nginx не запускается, выполнив команду:
vagrant@vagrant:~/kuber-files-03$ k get pods
NAME                                READY   STATUS     RESTARTS   AGE
nginx-deployment-7fdfdb4bdd-7p47d   0/1     Init:0/1   0          17s
vagrant@vagrant:~/kuber-files-03$
```
3. Создать и запустить Service. Убедиться, что Init запустился.

*[Service](https://github.com/Destian1995/kuber-files-03/blob/main/Service-2.yaml)

Перед запуском 
```
vagrant@vagrant:~/kuber-files-03$ kubectl describe pod nginx-deployment
Name:             nginx-deployment-7fdfdb4bdd-7p47d
Namespace:        default
Priority:         0
Service Account:  default
Node:             vagrant/10.0.2.15
Start Time:       Wed, 05 Apr 2023 07:44:45 +0000
Labels:           app=nginx
                  pod-template-hash=7f46b584c7
Annotations:      cni.projectcalico.org/containerID: 84fee8f4dcbda06713b2e22f070ef38e2ad8002962ce4906ab65809682980ea7
                  cni.projectcalico.org/podIP: 10.1.52.142/32
                  cni.projectcalico.org/podIPs: 10.1.52.142/32
Status:           Pending
IP:               10.1.52.142
IPs:
  IP:           10.1.52.142
Controlled By:  ReplicaSet/nginx-deployment-7f46b584c7
Init Containers:
  init-busybox:
    Container ID:  containerd://70e893d193f1f09e375b94d86ce51b8dc441e4dce4c143e4efc7dece1aba3009
    Image:         busybox
    Image ID:      docker.io/library/busybox@sha256:b5d6fe0712636ceb7430189de28819e195e8966372edfc2d9409d79402a0dc16
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      until nslookup nginx; do echo waiting for nginx; sleep 2; done;
    State:          Running
      Started:      Wed, 05 Apr 2023 07:46:11 +0000
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-lwwn4 (ro)
Containers:
  nginx:
    Container ID:
    Image:          nginx
    Image ID:
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       PodInitializing
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-lwwn4 (ro)
Conditions:
  Type              Status
  Initialized       False
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  kube-api-access-lwwn4:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:                      <none>

vagrant@vagrant:~/kuber-files-03$
```
Создали Service
```
vagrant@vagrant:~/kuber-files-03$ k apply -f Service-2.yaml
service/nginx-service created
```
после запуска проверяю состояние
```
vagrant@vagrant:~/kuber-files-03$ k get pods
NAME                                READY   STATUS            RESTARTS   AGE
nginx-deployment-7fdfdb4bdd-7p47d   0/1     PodInitializing   0          84s
```
Спустя время проверяю повторно
```
vagrant@vagrant:~/kuber-files-03$ k get pods
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-7fdfdb4bdd-7p47d   1/1     Running   0          11m
```

Вывод конфига пода
```
vagrant@vagrant:~/kuber-files-03$ k describe pods nginx-deployment-7fdfdb4bdd-7p47d
Name:             nginx-deployment-7fdfdb4bdd-7p47d
Namespace:        default
Priority:         0
Service Account:  default
Node:             vagrant/10.0.2.15
Start Time:       Wed, 05 Apr 2023 10:58:42 +0000
Labels:           app=nginx
                  pod-template-hash=7fdfdb4bdd
Annotations:      cni.projectcalico.org/containerID: 57e4ae538bd0e40a0a057b81c56b5638bac0bd8295e20f46b94e157714456bc0
                  cni.projectcalico.org/podIP: 10.1.52.149/32
                  cni.projectcalico.org/podIPs: 10.1.52.149/32
Status:           Running
IP:               10.1.52.149
IPs:
  IP:           10.1.52.149
Controlled By:  ReplicaSet/nginx-deployment-7fdfdb4bdd
Init Containers:
  wait-for-service:
    Container ID:  containerd://faf2103fc79930b9e63c0d28ac8f3d7e2ac17e304daab530ed0e78d6479bbe6b
    Image:         busybox
    Image ID:      docker.io/library/busybox@sha256:b5d6fe0712636ceb7430189de28819e195e8966372edfc2d9409d79402a0dc16
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      until nslookup nginx-service.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for nginx-service; sleep 2; done;
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Wed, 05 Apr 2023 10:59:07 +0000
      Finished:     Wed, 05 Apr 2023 11:00:02 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-mmbcf (ro)
Containers:
  nginx:
    Container ID:   containerd://8489d2095f93709ff0ed9746a83630db4c79fa3ebcac38f4d76e3592d821cf9e
    Image:          nginx
    Image ID:       docker.io/library/nginx@sha256:2ab30d6ac53580a6db8b657abf0f68d75360ff5cc1670a85acb5bd85ba1b19c0
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Wed, 05 Apr 2023 11:00:17 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-mmbcf (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-mmbcf:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:                      <none>
vagrant@vagrant:~/kuber-files-03$
```
4. Продемонстрировать состояние пода до и после запуска сервиса.

------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------
