# Домашнее задание к занятию "14.Средство визуализации Grafana"

## Задание повышенной сложности

**В части задания 1** не используйте директорию [help](./help) для сборки проекта, самостоятельно разверните grafana, где в 
роли источника данных будет выступать prometheus, а сборщиком данных node-exporter:
- grafana
- prometheus-server
- prometheus node-exporter

За дополнительными материалами, вы можете обратиться в официальную документацию grafana и prometheus.

В решении к домашнему заданию приведите также все конфигурации/скрипты/манифесты, которые вы 
использовали в процессе решения задания.

**В части задания 3** вы должны самостоятельно завести удобный для вас канал нотификации, например Telegram или Email
и отправить туда тестовые события.

В решении приведите скриншоты тестовых событий из каналов нотификаций.

## Обязательные задания

### Задание 1
Используя директорию [help](./help) внутри данного домашнего задания - запустите связку prometheus-grafana.

Зайдите в веб-интерфейс графана, используя авторизационные данные, указанные в манифесте docker-compose.

Подключите поднятый вами prometheus как источник данных.

Решение домашнего задания - скриншот веб-интерфейса grafana со списком подключенных Datasource.

Так же дополнительно попробовал вот такой манифест
```
version: '3'
services:
  prometheus:
    image: prom/prometheus
    ports:
      - 9090:9090
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    command:
      - --config.file=/etc/prometheus/prometheus.yml
      - --storage.tsdb.path=/prometheus
  node-exporter:
    image: prom/node-exporter
    user: root
    ports:
      - 9100:9100
  grafana:
    image: grafana/grafana
    ports:
      - 3000:3000
    volumes:
      - grafana-data:/var/lib/grafana
    depends_on:
      - prometheus
volumes:
  grafana-data:
  prometheus:
```

В этом манифесте, мы используем образы prom/prometheus, prom/node-exporter и grafana/grafana из Docker Hub. 
Мы открываем порты 9090 для Prometheus, 9100 для node-exporter, и 3000 для Grafana. 
Мы также монтируем конфигурационный файл Prometheus и директорию данных Grafana.

В конфигурационном файле prometheus.yml должны быть указаны источники данных node-exporter и счётчики, которые необходимо собирать.

Теперь в Grafana необходимо добавить datasource Prometheus и создать дашборды для отображения данных.

![1](https://user-images.githubusercontent.com/106807250/213429728-885243c8-3705-4d33-b1b8-97f94ec0e966.jpg)


## Задание 2
Изучите самостоятельно ресурсы:
- [promql-for-humans](https://timber.io/blog/promql-for-humans/#cpu-usage-by-instance)
- [understanding prometheus cpu metrics](https://www.robustperception.io/understanding-machine-cpu-usage)

Создайте Dashboard и в ней создайте следующие Panels:
- Утилизация CPU для nodeexporter (в процентах, 100-idle)
- CPULA 1/5/15
- Количество свободной оперативной памяти
- Количество места на файловой системе

Для решения данного ДЗ приведите promql запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

CPU
```
(((count(count(node_cpu_seconds_total{}) by (cpu))) - avg(sum by (mode)(rate(node_cpu_seconds_total{mode='idle'}[$__rate_interval])))) * 100) / count(count(node_cpu_seconds_total{}) by (cpu))

```
Free memory
```
node_memory_MemFree_bytes
```
Load Average
```
node_load1
node_load5
node_load15
```
Disk Free Space
```
node_filesystem_avail_bytes
```
![2](https://user-images.githubusercontent.com/106807250/213434130-52edecf1-fcd5-429c-83c9-edddad05b6f6.png)


## Задание 3
Создайте для каждой Dashboard подходящее правило alert (можно обратиться к первой лекции в блоке "Мониторинг").

Для решения ДЗ - приведите скриншот вашей итоговой Dashboard.
![3](https://user-images.githubusercontent.com/106807250/213434328-70f6bb0f-812f-483f-9792-341870ac8b45.png)



## Задание 4
Сохраните ваш Dashboard.

Для этого перейдите в настройки Dashboard, выберите в боковом меню "JSON MODEL".

Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.

В решении задания - приведите листинг этого файла.

[Dashboards](https://github.com/Destian1995/grafana/blob/main/node-dashboard.json)
---
