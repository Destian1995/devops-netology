# Домашнее задание к занятию "2. Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```
vagrant@vagrant:~/ansible-playbook$ sudo ansible-lint site.yml
[201] Trailing whitespace
site.yml:10
          - -q

[201] Trailing whitespace
site.yml:15


[201] Trailing whitespace
site.yml:66
          - -q

[206] Variables should have spaces before and after: {{ var_name }}
site.yml:88
        line: "{{ hostvars[item].ansible_host }} {{item}}"

[201] Trailing whitespace
site.yml:102
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```
[vagrant@localhost ansible-playbook]$ ansible-playbook -i inventory/prod.yml site.yml --check
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the controller starting with Ansible 2.12. Current version: 3.7.11 (default, Nov 15 2022, 11:12:07)
 [GCC 4.8.5 20150623 (Red Hat 4.8.5-44)]. This feature will be removed from ansible-core in version 2.12. Deprecation warnings can be disabled by setting
deprecation_warnings=False in ansible.cfg.
[WARNING]: Found both group and host with same name: clickhouse
[WARNING]: Found both group and host with same name: vector

PLAY [Drop database Clickhouse] ***************************************************************************************************************************************

PLAY [Install Clickhouse] *********************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************
ok: [clickhouse]

TASK [Get clickhouse distrib] *****************************************************************************************************************************************
ok: [clickhouse] => (item=clickhouse-client)
ok: [clickhouse] => (item=clickhouse-server)
failed: [clickhouse] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "vagrant", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "vagrant", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *****************************************************************************************************************************************
ok: [clickhouse]

TASK [Install clickhouse packages] ************************************************************************************************************************************
ok: [clickhouse]

TASK [Enable remote connections to clickhouse server] *****************************************************************************************************************
ok: [clickhouse]

TASK [Flush handlers] *************************************************************************************************************************************************

TASK [Create database] ************************************************************************************************************************************************
skipping: [clickhouse]

TASK [Create log table] ***********************************************************************************************************************************************
skipping: [clickhouse]

PLAY [Install Vector] *************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************
ok: [vector]

TASK [Add clickhouse addresses to /etc/hosts] *************************************************************************************************************************
ok: [vector] => (item=clickhouse)

TASK [Get vector distrib] *********************************************************************************************************************************************
ok: [vector]

TASK [Install vector package] *****************************************************************************************************************************************
ok: [vector]

TASK [Redefine vector config name] ************************************************************************************************************************************
ok: [vector]

TASK [Create vector config] *******************************************************************************************************************************************
ok: [vector]

PLAY RECAP ************************************************************************************************************************************************************
clickhouse                 : ok=4    changed=0    unreachable=0    failed=0    skipped=2    rescued=1    ignored=0
vector                     : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[vagrant@localhost ansible-playbook]$
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```
[vagrant@localhost ansible-playbook]$ ansible-playbook -i inventory/prod.yml site.yml --diff
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the controller starting with Ansible 2.12. Current version: 3.7.11 (default, Nov 15 2022, 11:12:07)
 [GCC 4.8.5 20150623 (Red Hat 4.8.5-44)]. This feature will be removed from ansible-core in version 2.12. Deprecation warnings can be disabled by setting
deprecation_warnings=False in ansible.cfg.
[WARNING]: Found both group and host with same name: vector
[WARNING]: Found both group and host with same name: clickhouse

PLAY [Drop database Clickhouse] ***************************************************************************************************************************************

PLAY [Install Clickhouse] *********************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************
ok: [clickhouse]

TASK [Get clickhouse distrib] *****************************************************************************************************************************************
ok: [clickhouse] => (item=clickhouse-client)
ok: [clickhouse] => (item=clickhouse-server)
failed: [clickhouse] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "vagrant", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "vagrant", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *****************************************************************************************************************************************
ok: [clickhouse]

TASK [Install clickhouse packages] ************************************************************************************************************************************
ok: [clickhouse]

TASK [Enable remote connections to clickhouse server] *****************************************************************************************************************
ok: [clickhouse]

TASK [Flush handlers] *************************************************************************************************************************************************

TASK [Create database] ************************************************************************************************************************************************
ok: [clickhouse]

TASK [Create log table] ***********************************************************************************************************************************************
ok: [clickhouse]

PLAY [Install Vector] *************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************
ok: [vector]

TASK [Add clickhouse addresses to /etc/hosts] *************************************************************************************************************************
ok: [vector] => (item=clickhouse)

TASK [Get vector distrib] *********************************************************************************************************************************************
changed: [vector]

TASK [Install vector package] *****************************************************************************************************************************************
changed: [vector]

TASK [Redefine vector config name] ************************************************************************************************************************************
--- before: /etc/default/vector (content)
+++ after: /etc/default/vector (content)
@@ -2,3 +2,4 @@
 # This file can theoretically contain a bunch of environment variables
 # for Vector.  See https://vector.dev/docs/setup/configuration/#environment-variables
 # for details.
+VECTOR_CONFIG=/etc/vector/config.yaml

changed: [vector]

TASK [Create vector config] *******************************************************************************************************************************************
--- before
+++ after: /home/vagrant/.ansible/tmp/ansible-local-218189dm8iqdn/tmp7heu4jlr
@@ -0,0 +1,27 @@
+api:
+  address: 0.0.0.0:8686
+  enabled: true
+sinks:
+  to_clickhouse:
+    compression: gzip
+    database: logs2
+    endpoint: http://clickhouse:8123
+    inputs:
+    - parse_logs
+    table: log
+    type: clickhouse
+sources:
+  dummy_logs:
+    format: syslog
+    interval: 1
+    type: demo_logs
+transforms:
+  parse_logs:
+    inputs:
+    - dummy_logs
+    source: '. = parse_syslog!(string!(.message))
+
+      .timestamp = to_string(.timestamp)
+
+      .timestamp = slice!(.timestamp, start:0, end: -1)'
+    type: remap

changed: [vector]

RUNNING HANDLER [Start Vector service] ********************************************************************************************************************************
changed: [vector]

PLAY RECAP ************************************************************************************************************************************************************
clickhouse                 : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector                     : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[vagrant@localhost ansible-playbook]$
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```
[vagrant@localhost ansible-playbook]$ ansible-playbook -i inventory/prod.yml site.yml --diff
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the controller starting with Ansible 2.12. Current version: 3.7.11 (default, Nov 15 2022, 11:12:07)
 [GCC 4.8.5 20150623 (Red Hat 4.8.5-44)]. This feature will be removed from ansible-core in version 2.12. Deprecation warnings can be disabled by setting
deprecation_warnings=False in ansible.cfg.
[WARNING]: Found both group and host with same name: clickhouse
[WARNING]: Found both group and host with same name: vector

PLAY [Drop database Clickhouse] ***************************************************************************************************************************************

PLAY [Install Clickhouse] *********************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************
ok: [clickhouse]

TASK [Get clickhouse distrib] *****************************************************************************************************************************************
ok: [clickhouse] => (item=clickhouse-client)
ok: [clickhouse] => (item=clickhouse-server)
failed: [clickhouse] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "vagrant", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "vagrant", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *****************************************************************************************************************************************
ok: [clickhouse]

TASK [Install clickhouse packages] ************************************************************************************************************************************
ok: [clickhouse]

TASK [Enable remote connections to clickhouse server] *****************************************************************************************************************
ok: [clickhouse]

TASK [Flush handlers] *************************************************************************************************************************************************

TASK [Create database] ************************************************************************************************************************************************
ok: [clickhouse]

TASK [Create log table] ***********************************************************************************************************************************************
ok: [clickhouse]

PLAY [Install Vector] *************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************
ok: [vector]

TASK [Add clickhouse addresses to /etc/hosts] *************************************************************************************************************************
ok: [vector] => (item=clickhouse)

TASK [Get vector distrib] *********************************************************************************************************************************************
ok: [vector]

TASK [Install vector package] *****************************************************************************************************************************************
ok: [vector]

TASK [Redefine vector config name] ************************************************************************************************************************************
ok: [vector]

TASK [Create vector config] *******************************************************************************************************************************************
ok: [vector]

PLAY RECAP ************************************************************************************************************************************************************
clickhouse                 : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector                     : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[vagrant@localhost ansible-playbook]$
```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

[Репозиторий с playbook ->](https://github.com/Destian1995/ansible-playbook)


---