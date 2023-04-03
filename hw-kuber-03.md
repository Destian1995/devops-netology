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
vagrant@vagrant:~/kuber-files-03$ kubectl --request-timeout 5m apply -f my-app.yaml
deployment.apps/my-app created
```
2. После запуска увеличить количество реплик работающего приложения до 2.
3. Продемонстрировать количество подов до и после масштабирования.

*до
```
vagrant@vagrant:~/kuber-files-03$ kubectl get pods
NAME                      READY   STATUS    RESTARTS      AGE
my-app-6c5cbf4897-97xs7   2/2     Running   4 (48s ago)   2m45s
```
*масштабируем
```
vagrant@vagrant:~/kuber-files-03$ kubectl scale deployment my-app --replicas=2
deployment.apps/my-app scaled

```
*после
```
vagrant@vagrant:~/kuber-files-03$ kubectl get pods
NAME                      READY   STATUS             RESTARTS       AGE
my-app-6c5cbf4897-97xs7   2/2     Running            4 (104s ago)   4m29s
my-app-6c5cbf4897-2jkhh   2/2     Running            0              22s
```
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.

* [Service](https://github.com/Destian1995/kuber-files-03/blob/main/Service.yaml)
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.
```
kubectl run multitool-pod --image=praqma/network-multitool --restart=Never
kubectl exec -it multitool-pod -- curl my-app-service
```
------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.

* [ngnix-deploymanet](https://github.com/Destian1995/kuber-files-03/blob/main/nginx.yaml)

2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
``
Init контейнер будет выполнять команду nslookup nginx до тех пор, пока не будет успешно выполнено. Это гарантирует, что сервис nginx будет доступен перед запуском основного контейнера.
``
```
После применения манифеста можно проверить, что nginx не запускается, выполнив команду:
vagrant@vagrant:~/kuber-files-03$ kubectl get pods
NAME                                READY   STATUS             RESTARTS        AGE
nginx-deployment-7f46b584c7-tdzmg   0/1     Init:0/1           0               18s
```
3. Создать и запустить Service. Убедиться, что Init запустился.
```
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: 80

```
Перед запуском 
```
vagrant@vagrant:~/kuber-files-03$ kubectl describe pod nginx
Name:             nginx-deployment-7f46b584c7-tdzmg
Namespace:        default
Priority:         0
Service Account:  default
Node:             vagrant/10.0.2.15
Start Time:       Mon, 03 Apr 2023 13:39:57 +0000
Labels:           app=nginx
                  pod-template-hash=7f46b584c7
Annotations:      cni.projectcalico.org/containerID: c4173b0a3f57ae5908f241a01d565f1e56ab2f2be6524b42132e97f9c993f53c
                  cni.projectcalico.org/podIP: 10.1.52.132/32
                  cni.projectcalico.org/podIPs: 10.1.52.132/32
Status:           Pending
IP:               10.1.52.132
IPs:
  IP:           10.1.52.132
Controlled By:  ReplicaSet/nginx-deployment-7f46b584c7
Init Containers:
  init-busybox:
    Container ID:  containerd://5dd8622c26299d71467c3d61946878a42fb0bd68be7aba571e4e7e963a302c59
    Image:         busybox
    Image ID:      docker.io/library/busybox@sha256:b5d6fe0712636ceb7430189de28819e195e8966372edfc2d9409d79402a0dc16
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      until nslookup nginx; do echo waiting for nginx; sleep 2; done;
    State:          Running
      Started:      Mon, 03 Apr 2023 13:40:10 +0000
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-jcnnb (ro)
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
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-jcnnb (ro)
Conditions:
  Type              Status
  Initialized       False
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  kube-api-access-jcnnb:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason             Age                From               Message
  ----     ------             ----               ----               -------
  Normal   Scheduled          94s                default-scheduler  Successfully assigned default/nginx-deployment-7f46b584c7-tdzmg to vagrant
  Normal   Pulling            88s                kubelet            Pulling image "busybox"
  Normal   Pulled             81s                kubelet            Successfully pulled image "busybox" in 6.180210554s (6.18592615s including waiting)
  Normal   Created            81s                kubelet            Created container init-busybox
  Normal   Started            81s                kubelet            Started container init-busybox
  Warning  MissingClusterDNS  79s (x4 over 93s)  kubelet            pod: "nginx-deployment-7f46b584c7-tdzmg_default(b1af2d67-a8d1-4576-b983-9622c41189a4)". kubelet does not have ClusterDNS IP configured and cannot create Pod using "ClusterFirst" policy. Falling back to "Default" policy.

vagrant@vagrant:~/kuber-files-03$
```
после запуска 
```
vagrant@vagrant:~/kuber-files-03$ kubectl describe pod nginx
Name:             nginx-deployment-7f46b584c7-tdzmg
Namespace:        default
Priority:         0
Service Account:  default
Node:             vagrant/10.0.2.15
Start Time:       Mon, 03 Apr 2023 13:39:57 +0000
Labels:           app=nginx
                  pod-template-hash=7f46b584c7
Annotations:      cni.projectcalico.org/containerID: c4173b0a3f57ae5908f241a01d565f1e56ab2f2be6524b42132e97f9c993f53c
                  cni.projectcalico.org/podIP: 10.1.52.132/32
                  cni.projectcalico.org/podIPs: 10.1.52.132/32
Status:           Pending
IP:               10.1.52.132
IPs:
  IP:           10.1.52.132
Controlled By:  ReplicaSet/nginx-deployment-7f46b584c7
Init Containers:
  init-busybox:
    Container ID:  containerd://5dd8622c26299d71467c3d61946878a42fb0bd68be7aba571e4e7e963a302c59
    Image:         busybox
    Image ID:      docker.io/library/busybox@sha256:b5d6fe0712636ceb7430189de28819e195e8966372edfc2d9409d79402a0dc16
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      until nslookup nginx; do echo waiting for nginx; sleep 2; done;
    State:          Running
      Started:      Mon, 03 Apr 2023 13:40:10 +0000
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-jcnnb (ro)
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
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-jcnnb (ro)
Conditions:
  Type              Status
  Initialized       False
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  kube-api-access-jcnnb:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason             Age                  From               Message
  ----     ------             ----                 ----               -------
  Normal   Scheduled          3m12s                default-scheduler  Successfully assigned default/nginx-deployment-7f46b584c7-tdzmg to vagrant
  Normal   Pulling            3m6s                 kubelet            Pulling image "busybox"
  Normal   Pulled             2m59s                kubelet            Successfully pulled image "busybox" in 6.180210554s (6.18592615s including waiting)
  Normal   Created            2m59s                kubelet            Created container init-busybox
  Normal   Started            2m59s                kubelet            Started container init-busybox
  Warning  MissingClusterDNS  20s (x6 over 3m11s)  kubelet            pod: "nginx-deployment-7f46b584c7-tdzmg_default(b1af2d67-a8d1-4576-b983-9622c41189a4)". kubelet does not have ClusterDNS IP configured and cannot create Pod using "ClusterFirst" policy. Falling back to "Default" policy.

vagrant@vagrant:~/kuber-files-03$
```
4. Продемонстрировать состояние пода до и после запуска сервиса.

------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------
