### Домашнее задание к занятию «Организация сети»

# Домашнее задание к занятию «Организация сети»

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашнее задание по теме «Облачные провайдеры и синтаксис Terraform». Заранее выберите регион (в случае AWS) и зону.

---
### Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

Resource Terraform для Yandex Cloud:

- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet).
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table).
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance).

---

Конфигурация:

* [main.tf](https://github.com/Destian1995/terra-org.network/blob/main/main.tf)
* [variables.tf](https://github.com/Destian1995/terra-org.network/blob/main/variables.tf)
* [versions.tf](https://github.com/Destian1995/terra-org.network/blob/main/versions.tf)


Проверяем валидность.
```
vagrant@vagrant:~/terra-org.network$ terraform validate
Success! The configuration is valid.
```

Разворачиваем
```
vagrant@vagrant:~/terra-org.network$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:
###
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_nat = "84.201.156.14"
external_ip_address_public = "130.193.36.188"
internal_ip_address_private = "192.168.20.34"
vagrant@vagrant:~/terra-org.network$
```
Готово:
![image](https://github.com/Destian1995/devops-netology/assets/106807250/6db93c7c-88bc-4a60-9554-08a81f3c8042)





Подключаемся
```
vagrant@vagrant:~/terra-org.network$ ssh ubuntu@130.193.36.188
Welcome to Ubuntu 22.04.2 LTS (GNU/Linux 5.15.0-69-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Jul 10 08:25:12 AM UTC 2023

  System load:  0.05126953125     Processes:             126
  Usage of /:   50.0% of 7.79GB   Users logged in:       0
  Memory usage: 11%               IPv4 address for eth0: 192.168.10.10
  Swap usage:   0%
```


Проверяем доступ в сеть из public
```
ubuntu@public-instance:~$ ping netology.ru
PING netology.ru (188.114.98.224) 56(84) bytes of data.
64 bytes from 188.114.98.224 (188.114.98.224): icmp_seq=1 ttl=55 time=59.4 ms
64 bytes from 188.114.98.224 (188.114.98.224): icmp_seq=2 ttl=55 time=58.9 ms
64 bytes from 188.114.98.224 (188.114.98.224): icmp_seq=3 ttl=55 time=58.9 ms
64 bytes from 188.114.98.224 (188.114.98.224): icmp_seq=4 ttl=55 time=59.0 ms
64 bytes from 188.114.98.224 (188.114.98.224): icmp_seq=5 ttl=55 time=59.0 ms
64 bytes from 188.114.98.224 (188.114.98.224): icmp_seq=6 ttl=55 time=59.0 ms
^C
--- netology.ru ping statistics ---
6 packets transmitted, 6 received, 0% packet loss, time 5007ms
rtt min/avg/max/mdev = 58.896/59.024/59.358/0.154 ms
ubuntu@public-instance:~$
```
![image](https://github.com/Destian1995/devops-netology/assets/106807250/c8f58d53-d475-4c79-8d79-7f1b286157d4)



Переключаемся в private предварительно пробросив ключик с помощью scp.
```
vagrant@vagrant:~/terra-org.network$ scp /home/vagrant/.ssh/id_rsa* ubuntu@130.193.36.188:~/.ssh/
id_rsa                                                                                100% 2602   121.1KB/s   00:00
id_rsa.pub                                                                            100%  569    27.3KB/s   00:00
```
Проверяем доступ из private
```
ubuntu@private-instance:~$ ping netology.ru
PING netology.ru (188.114.99.224) 56(84) bytes of data.
64 bytes from 188.114.99.224 (188.114.99.224): icmp_seq=1 ttl=53 time=54.6 ms
64 bytes from 188.114.99.224 (188.114.99.224): icmp_seq=2 ttl=53 time=53.1 ms
64 bytes from 188.114.99.224 (188.114.99.224): icmp_seq=3 ttl=53 time=53.0 ms
64 bytes from 188.114.99.224 (188.114.99.224): icmp_seq=4 ttl=53 time=53.4 ms
64 bytes from 188.114.99.224 (188.114.99.224): icmp_seq=5 ttl=53 time=53.3 ms
64 bytes from 188.114.99.224 (188.114.99.224): icmp_seq=6 ttl=53 time=53.3 ms
^C
--- netology.ru ping statistics ---
6 packets transmitted, 6 received, 0% packet loss, time 5008ms
rtt min/avg/max/mdev = 53.047/53.465/54.588/0.516 ms
```
![image](https://github.com/Destian1995/devops-netology/assets/106807250/4a2173ea-eaf1-4d9d-8466-0026e8ef1284)

