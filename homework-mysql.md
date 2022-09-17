## Задача 1


Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
---
```
docker run --rm --name mysql-docker \
    -e MYSQL_DATABASE=test_db \
    -e MYSQL_ROOT_PASSWORD=devops \
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

Создайте пользователя test в БД c паролем test-pass, используя:
---
-плагин авторизации mysql_native_password
-срок истечения пароля - 180 дней
-количество попыток авторизации - 3
-максимальное количество запросов в час - 100
-аттрибуты пользователя:
-Фамилия "Pretty"
-Имя "James"

```
mysql> CREATE USER 'test'@'localhost'
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
    ->     WITH MAX_CONNECTIONS_PER_HOUR 100
    ->     PASSWORD EXPIRE INTERVAL 180 DAY
    ->     FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2
    ->     ATTRIBUTE '{"first_name":"James", "last_name":"Pretty"}';
Query OK, 0 rows affected (0.05 sec)

mysql>
```

Предоставьте привелегии пользователю test на операции SELECT базы test_db.
---


```
mysql> grant select on test_db.* to 'test'@'localhost';
```

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.
---

```
mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user = 'test';
+------+-----------+------------------------------------------------+
| USER | HOST      | ATTRIBUTE                                      |
+------+-----------+------------------------------------------------+
| test | localhost | {"last_name": "Pretty", "first_name": "James"} |
+------+-----------+------------------------------------------------+
1 row in set (0.00 sec)

mysql>
```


## Задача 3

Исследуйте, какой engine используется в таблице БД test_db
Используется InnoDB
---

```
SELECT table_schema,table_name,engine FROM information_schema.tables WHERE table_schema = DATABASE();
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| test_db      | orders     | InnoDB |
+--------------+------------+--------+
1 row in set (0.00 sec)
```


---
```
mysql> set profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> alter table orders engine = 'MyISAM';
Query OK, 5 rows affected (0.11 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> alter table orders engine = 'InnoDB';
Query OK, 5 rows affected (0.08 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> set profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> alter table orders engine = 'MyISAM';
Query OK, 5 rows affected (0.06 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> alter table orders engine = 'InnoDB';
Query OK, 5 rows affected (0.08 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profiles;
+----------+------------+--------------------------------------+
| Query_ID | Duration   | Query                                |
+----------+------------+--------------------------------------+
|        1 | 0.00223300 | set profiling = 1                    |
|        2 | 0.06079525 | alter table orders engine = 'MyISAM' |
|        3 | 0.08464800 | alter table orders engine = 'InnoDB' |
+----------+------------+--------------------------------------+
```

## Задача 4 


```
bash-4.4# cd etc
bash-4.4# cat my.cnf

# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password

<<<<<<< HEAD
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

# Devops-netology
innodb_flush_log_at_trx_commit = 2
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 2.5G
innodb_log_file_size = 100M

bash-4.4#
```
=======
## Задача 4 
>>>>>>> 8388c0f9892333ad6fcb62d3c15826b99075e766
