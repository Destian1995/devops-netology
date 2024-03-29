# Домашнее задание к занятию "Микросервисы: масштабирование"


Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.

## Задача 1: Кластеризация

Предложите решение для обеспечения развертывания, запуска и управления приложениями.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- Поддержка контейнеров;
- Обеспечивать обнаружение сервисов и маршрутизацию запросов;
- Обеспечивать возможность горизонтального масштабирования;
- Обеспечивать возможность автоматического масштабирования;
- Обеспечивать явное разделение ресурсов доступных извне и внутри системы;
- Обеспечивать возможность конфигурировать приложения с помощью переменных среды, в том числе с возможностью безопасного хранения чувствительных данных таких как пароли, ключи доступа, ключи шифрования и т.п.

Обоснуйте свой выбор.


---

Возможные варианты:

| Name      | Containers |   Service Discovery    |  Horizontal Scaling | Autoscaling | Resource separation | Configs |
| :---:     |  :---:  |     :---:        | :---:  |      :---:  | :--: |        :---:  |
| kubernetes | + | internal DNS | + | + | + | secrets |
| redhat openshift | + | internal DNS | + | + | + | secrets |
| hashicorp nomad | + | native or consul | + | + | + | Vault |
| vmware tanzu | + |  internal DNS | + | + | + | secrets |
| docker swarm | + |  internal DNS | + | + | + | secrets |
| apache mesos | + |  internal DNS | + | + | + | secrets |

Все представленные решения можно условно разделить на две группы: 
- `kubernetes` и продукты на его основе (`openshift`, `tanzu`);
- самостоятельные оркестраторы.

Это сразу дает понимание того, что `kubernetes` является лидирующим продуктом в сфере оркестрации контейнеров. Учитывая поддержку со стороны публичных облачных платформ, выбор `kubernetes` в качестве решения для управления приложениями позволит с минимальными доработками деплоить приложения на родственные платформы и публичные облака.  
Из минусов платформы можно выделить не вполне безопасное хранение  паролей и ключей. Пароли и ключи обычно хранятся в объектах типа secret, которые не шифруются, а только кодируются алгоритмом base64. У пользователя, имеющего доступ к секретам черз API, есть возможность их чтения. Передача данных, содержащих объекты-секреты, по сети должна вестись только с шифрованием трафика. 
Для минимизации подобных недостатков в `nomad` применяется выделенный key management system: Hashicorp Vault. Подобные системы также есть в популярных публичных облаках.  
Также можно отметить, что `kubernetes` за редким исключением управляет только контейнерной инфраструктурой, в то время как `nomad`, `tanzu`, `mesos` позволяют управлять виртуальными машинами, сервисами и/или приложениями.

---