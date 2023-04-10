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
deployment.apps/app-deployment created
vagrant@vagrant:~/kuber-files-05$ k get pods
NAME                              READY   STATUS              RESTARTS   AGE
app-deployment-774d9fddcf-4j6h4   0/2     ContainerCreating   0          16s
app-deployment-774d9fddcf-m2x87   0/2     ContainerCreating   0          17s
app-deployment-774d9fddcf-szpx5   0/2     ContainerCreating   0          17s
vagrant@vagrant:~/kuber-files-05$ k get pods
NAME                              READY   STATUS    RESTARTS   AGE
app-deployment-774d9fddcf-szpx5   2/2     Running   0          9m30s
app-deployment-774d9fddcf-4j6h4   2/2     Running   0          9m30s
app-deployment-774d9fddcf-m2x87   2/2     Running   0          9m30s
vagrant@vagrant:~/kuber-files-05$
```
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.

* [Service](https://github.com/Destian1995/kuber-files-05/blob/main/Service1.yaml)

3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.

```
kubectl run multitool-pod --image=wbitt/network-multitool --restart=Never
```
Проверка доступа по разным портам:
```
$ kubectl exec -it multitool-pod -- /bin/bash
root@multitool-pod:/# curl http://app-service:9001
root@multitool-pod:/# curl http://app-service:9002
```
4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.
```
$ kubectl exec -it multitool-pod -- /bin/bash
root@multitool-pod:/# curl http://app-service.nginx.svc.cluster.local:9001
```

5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
* [Service](https://github.com/Destian1995/kuber-files-05/blob/main/Service2.yaml)
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.

Через браузер:

Узнаем IP ноды:
```
kubectl get nodes
```
И подставляем:
```
https://<node-ip>:30001/
```
Через curl:
```
$ curl http://<node-ip>:30001/
```
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

