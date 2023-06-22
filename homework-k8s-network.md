# Домашнее задание к занятию «Как работает сеть в K8s»

### Цель задания

Настроить сетевую политику доступа к подам.

### Чеклист готовности к домашнему заданию

1. Кластер K8s с установленным сетевым плагином Calico.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
  * [frontend](https://github.com/Destian1995/k8s-dep/blob/main/frontend.yaml)
  * [backend](https://github.com/Destian1995/k8s-dep/blob/main/backend.yaml)
  * [cache](https://github.com/Destian1995/k8s-dep/blob/main/cache.yaml)
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешён и запрещён.

Создаем namespace

```
vagrant@vagrant:~/k8s-dep$ kubectl apply -f namespace.yaml
namespace/app created
vagrant@vagrant:~/k8s-dep$  kubectl get ns
NAME              STATUS   AGE
kube-system       Active   69d
kube-public       Active   69d
kube-node-lease   Active   69d
default           Active   69d
ingress           Active   67d
app               Active   3m43s
```
Далее создаем deployment'ы и сервисы.
```
vagrant@vagrant:~/k8s-dep$ kubectl apply -f frontend.yaml
deployment.apps/frontend created
service/frontend created
vagrant@vagrant:~/k8s-dep$ kubectl apply -f backend.yaml
deployment.apps/backend created
service/backend created
vagrant@vagrant:~/k8s-dep$ kubectl apply -f cache.yaml
deployment.apps/cache created
service/cache created
```
Проверка
```
vagrant@vagrant:~/k8s-dep$ kubectl get deployment -n app
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
cache      1/1     1            1           6m8s
frontend   1/1     1            1           6m47s
backend    1/1     1            1           6m19s
vagrant@vagrant:~/k8s-dep$ kubectl get service -n app
NAME       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
frontend   ClusterIP   10.152.183.227   <none>        80/TCP    4m50s
backend    ClusterIP   10.152.183.107   <none>        80/TCP    4m24s
cache      ClusterIP   10.152.183.178   <none>        80/TCP    4m13s
vagrant@vagrant:~/k8s-dep$ kubectl get pods -o wide -n app
NAME                        READY   STATUS    RESTARTS   AGE   IP            NODE      NOMINATED NODE   READINESS GATES
cache-9d4b97449-k9mmd       1/1     Running   0          39h   10.1.52.153   vagrant   <none>           <none>
frontend-7f55d7684c-nwhfp   1/1     Running   0          39h   10.1.52.154   vagrant   <none>           <none>
backend-5dd9956847-rmrhw    1/1     Running   0          39h   10.1.52.155   vagrant   <none>           <none>
```
Создаем сетевые политики
```
vagrant@vagrant:~/k8s-dep$ kubectl apply -f network_policy.yaml
networkpolicy.networking.k8s.io/all-deny created
networkpolicy.networking.k8s.io/frontend-to-backend created
networkpolicy.networking.k8s.io/backend-to-cache created

vagrant@vagrant:~/k8s-dep$ kubectl get networkpolicies -n app
NAME                  POD-SELECTOR   AGE
all-deny              <none>         6m22s
frontend-to-backend   app=backend    6m19s
backend-to-cache      app=cache      6m19s
```

Проверяем что трафик запрещен и разрешен.
```

```
### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
