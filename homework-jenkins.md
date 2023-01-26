# Домашнее задание к занятию "10.Jenkins"

## Подготовка к выполнению

1. Создать 2 VM: для jenkins-master и jenkins-agent.
2. Установить jenkins при помощи playbook'a.
3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.
4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline][./pipeline](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/09-ci-04-jenkins/pipeline).
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True), по умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.

-
[vector-role Jenkinsfile](https://github.com/Destian1995/devops-netology/blob/vector-role/Jenkinsfile)
-
[lighthouse-role Jenkinsfile](https://github.com/Destian1995/devops-netology/blob/lighthouse-role/Jenkinsfile)
-
[ScriptedJenkinsfile](https://github.com/Destian1995/Jenkins/blob/main/homework/ScriptedJenkinsfile)
-



--
[exported jobs](https://github.com/Destian1995/Jenkins/tree/main/homework/xml)
