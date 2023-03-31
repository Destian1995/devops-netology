# Домашнее задание к занятию «Базовые объекты K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Pod с приложением и подключиться к нему со своего локального компьютера. 

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Описание [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) и примеры манифестов.
2. Описание [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

------

### Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.

* [Pod](https://github.com/Destian1995/kuber-files/blob/main/Pod.yaml)
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).
```
vagrant@vagrant:~/kuber-files$ kubectl apply -f Pod.yaml
pod/hello-world created
```
![hello-world](https://user-images.githubusercontent.com/106807250/229056467-d7912df7-87a0-4f82-b0c1-25a8657bc6e7.jpg)

------

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.
 
* [Pod-netology-web](https://github.com/Destian1995/kuber-files/blob/main/netology-web.yaml)
```
vagrant@vagrant:~/kuber-files$ kubectl apply -f netology-web.yaml
pod/netology-web created
```
![pod](https://user-images.githubusercontent.com/106807250/229061715-34a3fd1a-1c31-455e-b932-45b62ea23a7d.jpg)

2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Создать Service с именем netology-svc и подключить к netology-web.
```
vagrant@vagrant:~/kuber-files$ kubectl apply -f Service.yaml
service/netology-svc created
```
* [Pod-netology-svc](https://github.com/Destian1995/kuber-files/blob/main/Service.yaml) 
4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).
![Services](https://user-images.githubusercontent.com/106807250/229061745-c5530625-dd1f-4788-bed7-b75b5ff8162f.jpg)

------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода команд `kubectl get pods`, а также скриншот результата подключения.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------
