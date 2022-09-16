## Задача 1


Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
---
```
docker run --rm --name mysql-docker \
    -e MYSQL_DATABASE=test_db \
    -e MYSQL_ROOT_PASSWORD=netology \
    -v $PWD/backup:/media/mysql/backup \
    -v my_data:/var/lib/mysql \
    -v $PWD/config/conf.d:/etc/mysql/conf.d \
    -p 3306:3306 \
    -d mysql:8.0
```
	
Изучите бэкап БД и восстановитесь из него.
---
```
vagrant@vagrant:~$ sudo docker exec -it mysql-docker bash
bash-4.4# mysql -u root -p test_db < /tmp/test_dump.sql
Enter password:
bash-4.4#
```

Перейдите в управляющую консоль mysql внутри контейнера.
---

```
vagrant@vagrant:~$ sudo docker exec -it mysql-docker bash
bash-4.4# mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 21
Server version: 8.0.30 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> \q
```

Используя команду \h получите список управляющих команд.

Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.
---
```
mysql> \s
--------------
mysql  Ver 8.0.30 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          22
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.30 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 16 min 16 sec

Threads: 2  Questions: 37  Slow queries: 0  Opens: 138  Flush tables: 3  Open tables: 56  Queries per second avg: 0.037
--------------

mysql>

```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.
---

```
mysql> USE test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql>
```

Приведите в ответе количество записей с price > 300.
---

```
mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.01 sec)

mysql>
```

В следующих заданиях мы будем продолжать работу с данным контейнером.


## Задача 2








## Задача 3









## Задача 4 