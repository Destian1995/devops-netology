# Домашнее задание к занятию «Обновление приложений»

### Цель задания

Выбрать и настроить стратегию обновления приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment).
2. [Статья про стратегии обновлений](https://habr.com/ru/companies/flant/articles/471620/).

-----

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.

> В зависимости от специфики использования приложения я бы использовал следуюшие стратегии:

* Eсли допустима недоступность приложения, то я бы выбрал стратегию Recreate, так как у нас ограниченное количество дополнительных ресурсов. Старые реплики будут уничтожены и запущены обновленные вместо них. Кроме 
  того обновление мажорное, то есть части приложения будут обновлены все вместе, что защитит от проблем с совместимостью.
* Если недоступность приложения недопустима, то я бы выбрал стратегию RollingUpdate, это поможет безопасно перейти на новую версию, постепенно удаляя старые поды после того как поднимутся новые. Мы можем указать лимиты в Deployment в 20% вместо 25%, и при этом у нас не будет простоя сервиса. Постепенно уменьшаем количество старых реплик на новые и постепенно переводим на новые реплики трафик по какому-нибудь признаку.

### Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.

  * [Deployment](https://github.com/Destian1995/k8s-update-app/blob/main/nginx-multitool.yaml)
```
vagrant@vagrant:~/k8s-update-app$ kubectl apply -f nginx-multitool.yaml
deployment.apps/nginx-multitool created
vagrant@vagrant:~/k8s-update-app$ kubectl get pods -o wide
NAME                               READY   STATUS    RESTARTS   AGE     IP            NODE      NOMINATED NODE   READINESS GATES
nginx-multitool-748b869d84-tqz7b   2/2     Running   0          5m41s   10.1.52.160   node1     <none>           <none>
nginx-multitool-748b869d84-rqq5q   2/2     Running   0          5m41s   10.1.52.161   node2     <none>           <none>
nginx-multitool-748b869d84-59ts5   2/2     Running   0          5m42s   10.1.52.162   node3     <none>           <none>
nginx-multitool-748b869d84-98j2n   2/2     Running   0          5m43s   10.1.52.163   node4     <none>           <none>
nginx-multitool-748b869d84-xbtcn   2/2     Running   0          5m42s   10.1.52.165   node5     <none>           <none>
```
  
2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.
```
Меняю версию nginx-а в Deployment-е.
Для обновления выбрал стратегию RollingUpdate.
Для ускорения обновления приложения необходимо увеличить максимально возможно ресурсы,
потребляемые сверх "штатной" работы приложения (если позволяет возможность) (maxSurge: 80%)
и минимизировать количество рабочих реплик (но не менее 1) ( maxUnavailable: 80%).

vagrant@vagrant:~/k8s-update-app$ kubectl get pods -o wide
NAME                               READY   STATUS              RESTARTS   AGE    IP            NODE      NOMINATED NODE   READINESS GATES
nginx-multitool-748b869d84-59ts5   2/2     Running             0          31m    10.1.52.162   node3     <none>           <none>
nginx-multitool-6c98cfbb56-kvrg7   0/2     ContainerCreating   0          7m9s   <none>        node1     <none>           <none>
nginx-multitool-6c98cfbb56-64986   0/2     ContainerCreating   0          7m8s   <none>        node5     <none>           <none>
nginx-multitool-6c98cfbb56-2g26l   0/2     ContainerCreating   0          7m8s   <none>        node2     <none>           <none>
nginx-multitool-6c98cfbb56-6fs4h   0/2     ContainerCreating   0          32s    <none>        node3     <none>           <none>
nginx-multitool-6c98cfbb56-jz8n9   0/2     ContainerCreating   0          7m7s   <none>        node4     <none>           <none>


готово
vagrant@vagrant:~/k8s-update-app$ kubectl get pods -o wide
NAME                               READY   STATUS    RESTARTS   AGE     IP            NODE      NOMINATED NODE   READINESS GATES
nginx-multitool-6c98cfbb56-kvrg7   2/2     Running   0          12m     10.1.52.166   node1     <none>           <none>
nginx-multitool-6c98cfbb56-jz8n9   2/2     Running   0          12m     10.1.52.169   node4     <none>           <none>
nginx-multitool-6c98cfbb56-6fs4h   2/2     Running   0          6m12s   10.1.52.168   node3     <none>           <none>
nginx-multitool-6c98cfbb56-64986   2/2     Running   0          12m     10.1.52.170   node5     <none>           <none>
nginx-multitool-6c98cfbb56-2g26l   2/2     Running   0          12m     10.1.52.171   node2     <none>           <none>
vagrant@vagrant:~/k8s-update-app$
```
   
4. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.
>Снова меняем версию в Deployment
```
spec:
      containers:
      - name: nginx
        image: nginx:1.28
```
>И запускаем обновление. 
```
vagrant@vagrant:~/k8s-update-app$ kubectl apply -f nginx-multitool.yaml
deployment.apps/nginx-multitool configured

Спустя время видим что поды падают в ошибку и пытаются пересоздаться.

vagrant@vagrant:~/k8s-update-app$ kubectl get pods -o wide
NAME                               READY   STATUS              RESTARTS   AGE   IP            NODE      NOMINATED NODE   READINESS GATES
nginx-multitool-6c98cfbb56-2g26l   2/2     Running             0          54m   10.1.52.171   node2     <none>           <none>
nginx-multitool-6f585b5848-8gkgh   0/2     ContainerCreating   0          32m   <none>        node2     <none>           <none>
nginx-multitool-6f585b5848-lqn6l   0/2     ContainerCreating   0          32m   <none>        node1     <none>           <none>
nginx-multitool-6f585b5848-9m8pr   0/2     ContainerCreating   0          31m   <none>        node4     <none>           <none>
nginx-multitool-6f585b5848-tqn97   0/2     ContainerCreating   0          32m   <none>        node3     <none>           <none>
nginx-multitool-6c98cfbb56-jz8n9   0/2     Terminating         0          54m   <none>        node5     <none>           <none>
nginx-multitool-6f585b5848-k7hvq   0/2     ContainerCreating   0          32m   10.1.52.172   node5     <none>           <none>
vagrant@vagrant:~/k8s-update-app$
```
   
5. Откатиться после неудачного обновления.

>Выясняем какая была последняя рабочая версия
```
vagrant@vagrant:~/k8s-update-app$ kubectl rollout history deployment nginx-multitool view
deployment.apps/nginx-multitool
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
3         <none>

vagrant@vagrant:~/k8s-update-app$ kubectl rollout history deployment nginx-multitool --revision=2
deployment.apps/nginx-multitool with revision #2
Pod Template:
  Labels:       app=nginx-multitool
        pod-template-hash=6c98cfbb56
  Containers:
   nginx:
    Image:      nginx:1.20
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:        <none>
    Mounts:     <none>
   multitool:
    Image:      wbitt/network-multitool
    Port:       8080/TCP
    Host Port:  0/TCP
    Environment:
      HTTP_PORT:        8080
      HTTPS_PORT:       11443
    Mounts:     <none>
  Volumes:      <none>
```
>После того как выяснили последнюю рабочую версию, откатываемся
```
vagrant@vagrant:~/k8s-update-app$ kubectl rollout undo deployment nginx-multitool --to-revision=2
deployment.apps/nginx-multitool rolled back
```
>Все встало обратно
```
vagrant@vagrant:~/k8s-update-app$ kubectl get pods -o wide
NAME                               READY   STATUS    RESTARTS   AGE     IP            NODE      NOMINATED NODE   READINESS GATES
nginx-multitool-6c98cfbb56-2g26l   2/2     Running   0          74m     10.1.52.171   node2     <none>           <none>
nginx-multitool-6c98cfbb56-2g89h   2/2     Running   0          10m     10.1.52.173   node1     <none>           <none>
nginx-multitool-6c98cfbb56-nntlb   2/2     Running   0          10m     10.1.52.174   node5     <none>           <none>
nginx-multitool-6c98cfbb56-clm6j   2/2     Running   0          9m58s   10.1.52.175   node3     <none>           <none>
nginx-multitool-6c98cfbb56-dkgb6   2/2     Running   0          10m     10.1.52.176   node4     <none>           <none>

```
   

## Дополнительные задания — со звёздочкой*

Задания дополнительные, необязательные к выполнению, они не повлияют на получение зачёта по домашнему заданию. **Но мы настоятельно рекомендуем вам выполнять все задания со звёздочкой.** Это поможет лучше разобраться в материале.   

### Задание 3*. Создать Canary deployment

1. Создать два deployment'а приложения nginx.
2. При помощи разных ConfigMap сделать две версии приложения — веб-страницы.
3. С помощью ingress создать канареечный деплоймент, чтобы можно было часть трафика перебросить на разные версии приложения.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле RE
