# Домашнее задание к занятию «Хранение в K8s. Часть 1»

### Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.

*  [Deployment](https://github.com/Destian1995/kuber-files-06/blob/main/Deployment.yaml)

2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.

3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
```
vagrant@vagrant:~/kuber-files-06$ k apply -f Deployment.yaml
deployment.apps/deployment-multi-busy created
vagrant@vagrant:~/kuber-files-06$ k get pods
NAME                                     READY   STATUS    RESTARTS   AGE
deployment-multi-busy-6b98875cdf-9pvwm   2/2     Running   0          52s
vagrant@vagrant:~/kuber-files-06$ kubectl exec -it deployment-multi-busy-6b98875cdf-9pvwm -c busybox -- sh
/ # cat tmp/cache/1.txt
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
vagrant@vagrant:~/kuber-files-06$  kubectl exec -it deployment-multi-busy-6b98875cdf-9pvwm -c multitool -- sh
/ # cat multitool/1.txt
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
Test text
/ #
```

5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.

* [DaemonSet](https://github.com/Destian1995/kuber-files-06/blob/main/DaemonSet.yaml)

2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
```
vagrant@vagrant:~/kuber-files-06$ k get pods
NAME                                     READY   STATUS    RESTARTS   AGE
deployment-multi-busy-6b98875cdf-9pvwm   2/2     Running   0          4m56s
ds-multitool-8ck6c                       1/1     Running   0          60s
vagrant@vagrant:~/kuber-files-06$ kubectl exec -it ds-multitool-8ck6c -- sh
/ # tail multitool/syslog
Apr 17 06:15:29 vagrant systemd[83616]: run-containerd-runc-k8s.io-516f7793bd028d1e9ffa5a91907d8c63356dd203fb2e872d09011fbd81f9ed17-runc.vz5tpM.mount: Succeeded.
Apr 17 06:15:29 vagrant systemd[1]: run-containerd-runc-k8s.io-516f7793bd028d1e9ffa5a91907d8c63356dd203fb2e872d09011fbd81f9ed17-runc.vz5tpM.mount: Succeeded.
Apr 17 06:15:44 vagrant systemd[83616]: run-containerd-runc-k8s.io-516f7793bd028d1e9ffa5a91907d8c63356dd203fb2e872d09011fbd81f9ed17-runc.GQmL2N.mount: Succeeded.
Apr 17 06:15:44 vagrant systemd[1]: run-containerd-runc-k8s.io-516f7793bd028d1e9ffa5a91907d8c63356dd203fb2e872d09011fbd81f9ed17-runc.GQmL2N.mount: Succeeded.
Apr 17 06:15:49 vagrant systemd[83616]: run-containerd-runc-k8s.io-516f7793bd028d1e9ffa5a91907d8c63356dd203fb2e872d09011fbd81f9ed17-runc.xYBNB6.mount: Succeeded.
Apr 17 06:15:49 vagrant systemd[1]: run-containerd-runc-k8s.io-516f7793bd028d1e9ffa5a91907d8c63356dd203fb2e872d09011fbd81f9ed17-runc.xYBNB6.mount: Succeeded.
Apr 17 06:15:57 vagrant microk8s.daemon-kubelite[112843]: E0417 06:15:57.757015  112843 queueset.go:461] "Overflow" err="queueset::currentR overflow" QS="workload-high" when="2023-04-17 06:15:57.739800239" prevR="31.63220122ss" incrR="184467440737.09549899ss" currentR="31.63218405ss"
Apr 17 06:15:57 vagrant microk8s.daemon-kubelite[112843]: E0417 06:15:57.792337  112843 queueset.go:461] "Overflow" err="queueset::currentR overflow" QS="workload-high" when="2023-04-17 06:15:57.792279851" prevR="31.70445861ss" incrR="184467440737.09549708ss" currentR="31.70443953ss"
Apr 17 06:15:59 vagrant systemd[1]: run-containerd-runc-k8s.io-516f7793bd028d1e9ffa5a91907d8c63356dd203fb2e872d09011fbd81f9ed17-runc.h4Vxix.mount: Succeeded.
Apr 17 06:15:59 vagrant systemd[83616]: run-containerd-runc-k8s.io-516f7793bd028d1e9ffa5a91907d8c63356dd203fb2e872d09011fbd81f9ed17-runc.h4Vxix.mount: Succeeded.
/ #
```

4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
