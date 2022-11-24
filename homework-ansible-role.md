# Домашнее задание к занятию "4. Работа с roles"

## Подготовка к выполнению
1. (Необязательно) Познакомтесь с [lighthouse](https://youtu.be/ymlrNlaHzIY?t=929)
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю в github.

## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для clickhouse, vector и lighthouse и написать playbook для использования этих ролей. Ожидаемый результат: существуют три ваших репозитория: два с roles и один с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачать себе эту роль.
3. Создать новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Описать в `README.md` обе роли и их параметры.
7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию Добавьте roles в `requirements.yml` в playbook.
Теги проставил благодаря чему успешно прошла команда:
```
[vagrant@localhost ansible-role]$ ansible-galaxy install -r requirements.yml -p roles
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the controller starting with Ansible 2.12. Current
version: 3.7.11 (default, Nov 15 2022, 11:12:07) [GCC 4.8.5 20150623 (Red Hat 4.8.5-44)]. This feature will be removed from
 ansible-core in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
Starting galaxy role install process
- extracting clickhouse to /home/vagrant/ansible-role/roles/clickhouse
- clickhouse (1.11.1) was installed successfully
- extracting vector-role to /home/vagrant/ansible-role/roles/vector-role
- vector-role (vector-role) was installed successfully
- extracting lighthouse-role to /home/vagrant/ansible-role/roles/lighthouse-role
- lighthouse-role (1.0.2) was installed successfully
[vagrant@localhost ansible-role]$
```
9. Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

--
[lighthouse-role](https://github.com/Destian1995/lighthouse-role)
--
[vector-role](https://github.com/Destian1995/vector-role)
--
[playbook](https://github.com/Destian1995/ansible-role)
---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
