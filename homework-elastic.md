# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ elasticsearch:7 как базовый:

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`
elasticsearch.yml:
```
cluster.name: netology_test
node.name: netology_test
bootstrap.memory_lock: true
network.host: 127.0.0.1
network.publish_host: localhost
path.data: /var/lib/elasticsearch/data
path.logs: /var/lib/elasticsearch/logs
path.repo: /var/lib/elasticsearch/snapshots
http.port: 9200-9300
```
В ответе приведите:
- текст Dockerfile манифеста


```
FROM docker.elastic.co/elasticsearch/elasticsearch:7.17.6
RUN apt-get update && apt-get install wget build-essential gcc make -y
RUN apt-get install common-software-properties  -y
#Install_JAVA
RUN apt-get install default-jdk -y
RUN apt-get install openjdk-8-jre -y
RUN apt-get update
RUN wget -O - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN echo  "deb  http://packages.elastic.co/elasticsearch/2.x/debian stable main" | tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
RUN apt-get update &&  apt-get install elasticsearch -y
RUN apt-get install git -y
RUN apt-get install python2.7 -y
RUN apt-get install vim  -y
#configuration_to_PubilsOverSSH
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
RUN service ssh restart

```

```
sudo docker build . -t destian1995/elasticsearch:7.17
sudo docker login -u destian1995 -p Destian17 docker.io
sudo docker push destian1995/elasticsearch:7.17
```


- ссылку на образ в репозитории dockerhub
https://hub.docker.com/repository/docker/destian1995/elasticsearch


- ответ `elasticsearch` на запрос пути `/` в json виде

```
vagrant@vagrant:~$ sudo docker run -it --rm -d --name elasticsearch -p 9200:9200 -p 9300:9300 destian1995/elasticsearch:7.17
3e921bb9ccf530cec35a9e12d327e9b021275562788715a39b4617ae3a7ebc87
vagrant@vagrant:~$ sudo docker ps
CONTAINER ID   IMAGE                            COMMAND                  CREATED         STATUS         PORTS                                                                                  NAMES
3e921bb9ccf5   destian1995/elasticsearch:7.17   "/bin/tini -- /usr/l…"   5 seconds ago   Up 4 seconds   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp   elasticsearch
vagrant@vagrant:~$ sudo curl -X GET 'localhost:9200/'
```

```

```

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```
```

```
```

```
```

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

```
```

Получите состояние кластера `elasticsearch`, используя API.

```
```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

```
```

Удалите все индексы.

```
```

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

```
```

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

```
```

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

```
```

**Приведите в ответе** список файлов в директории со `snapshot`ами.

```
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

```
```

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```
```

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
