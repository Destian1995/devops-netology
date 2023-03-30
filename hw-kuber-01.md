# Домашнее задание к занятию «Kubernetes. Причины появления. Команда kubectl»

### Цель задания

Для экспериментов и валидации ваших решений вам нужно подготовить тестовую среду для работы с Kubernetes. Оптимальное решение — развернуть на рабочей машине или на отдельной виртуальной машине MicroK8S.

------

### Чеклист готовности к домашнему заданию

1. Личный компьютер с ОС Linux или MacOS 

или

2. ВМ c ОС Linux в облаке либо ВМ на локальной машине для установки MicroK8S  

------

### Инструкция к заданию

1. Установка MicroK8S:
    - sudo apt update,
    - sudo apt install snapd,
    - sudo snap install microk8s --classic,
    - добавить локального пользователя в группу `sudo usermod -a -G microk8s $USER`,
    - изменить права на папку с конфигурацией `sudo chown -f -R $USER ~/.kube`.

2. Полезные команды:
    - проверить статус `microk8s status --wait-ready`;
    - подключиться к microK8s и получить информацию можно через команду `microk8s command`, например, `microk8s kubectl get nodes`;
    - включить addon можно через команду `microk8s enable`; 
    - список addon `microk8s status`;
    - вывод конфигурации `microk8s config`;
    - проброс порта для подключения локально `microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443`.

3. Настройка внешнего подключения:
    - отредактировать файл /var/snap/microk8s/current/certs/csr.conf.template
    ```shell
    # [ alt_names ]
    # Add
    # IP.4 = 123.45.67.89
    ```
    - обновить сертификаты `sudo microk8s refresh-certs --cert front-proxy-client.crt`.

4. Установка kubectl:
    - curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl;
    - chmod +x ./kubectl;
    - sudo mv ./kubectl /usr/local/bin/kubectl;
    - настройка автодополнения в текущую сессию `bash source <(kubectl completion bash)`;
    - добавление автодополнения в командную оболочку bash `echo "source <(kubectl completion bash)" >> ~/.bashrc`.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Инструкция](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/#bash) по установке автодополнения **kubectl**.
3. [Шпаргалка](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/) по **kubectl**.

------

### Задание 1. Установка MicroK8S

1. Установить MicroK8S на локальную машину или на удалённую виртуальную машину.
2. Установить dashboard.
3. Сгенерировать сертификат для подключения к внешнему ip-адресу.

------

### Задание 2. Установка и настройка локального kubectl
1. Установить на локальную машину kubectl.
2. Настроить локально подключение к кластеру.
3. Подключиться к дашборду с помощью port-forward.

------
### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода команд `kubectl get nodes` и скриншот дашборда.

```
vagrant@vagrant:~$ kubectl get nodes
NAME      STATUS   ROLES    AGE   VERSION
vagrant   Ready    <none>   17h   v1.26.1
```
Вот далее затык...


``
Кратко: 
развернул на ВМ vagrant microk8s. Локально с самого хоста с дашбордом curl проходит успешно.
А вот удаленно подключится с клиента к хосту ВМ с дашбордом не удается.  по причине ERR_CONNECTION_TIMED_OUT либо ERR_CONNECTION_REFUSED
если пытаюсь использовать  https://localhost:10443
``
Могу скинуть curl с того же хоста с дашбордом чтобы продемонстрировать что все работает.

<details>

__<summary>Вывод curl</summary>__

```
vagrant@vagrant:~$ curl localhost:8001/api/v1/pods
{
  "kind": "PodList",
  "apiVersion": "v1",
  "metadata": {
    "resourceVersion": "4884"
  },
  "items": [
    {
      "metadata": {
        "name": "dashboard-metrics-scraper-7bc864c59-bhd69",
        "generateName": "dashboard-metrics-scraper-7bc864c59-",
        "namespace": "kube-system",
        "uid": "6df397ec-e85b-48fd-801e-cae9381e7c86",
        "resourceVersion": "3520",
        "creationTimestamp": "2023-03-29T10:34:51Z",
        "labels": {
          "k8s-app": "dashboard-metrics-scraper",
          "pod-template-hash": "7bc864c59"
        },
        "annotations": {
          "cni.projectcalico.org/containerID": "71a4205ec0f581a09630680b39b8ed3eec7b6fddebf5520d6e5241e48decc511",
          "cni.projectcalico.org/podIP": "10.1.52.135/32",
          "cni.projectcalico.org/podIPs": "10.1.52.135/32"
        },
        "ownerReferences": [
          {
            "apiVersion": "apps/v1",
            "kind": "ReplicaSet",
            "name": "dashboard-metrics-scraper-7bc864c59",
            "uid": "dae62cd7-149d-474a-8b8f-6c0a6ca46327",
            "controller": true,
            "blockOwnerDeletion": true
          }
        ],
        "managedFields": [
          {
            "manager": "kubelite",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-29T10:34:51Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:metadata": {
                "f:generateName": {},
                "f:labels": {
                  ".": {},
                  "f:k8s-app": {},
                  "f:pod-template-hash": {}
                },
                "f:ownerReferences": {
                  ".": {},
                  "k:{\"uid\":\"dae62cd7-149d-474a-8b8f-6c0a6ca46327\"}": {}
                }
              },
              "f:spec": {
                "f:containers": {
                  "k:{\"name\":\"dashboard-metrics-scraper\"}": {
                    ".": {},
                    "f:image": {},
                    "f:imagePullPolicy": {},
                    "f:livenessProbe": {
                      ".": {},
                      "f:failureThreshold": {},
                      "f:httpGet": {
                        ".": {},
                        "f:path": {},
                        "f:port": {},
                        "f:scheme": {}
                      },
                      "f:initialDelaySeconds": {},
                      "f:periodSeconds": {},
                      "f:successThreshold": {},
                      "f:timeoutSeconds": {}
                    },
                    "f:name": {},
                    "f:ports": {
                      ".": {},
                      "k:{\"containerPort\":8000,\"protocol\":\"TCP\"}": {
                        ".": {},
                        "f:containerPort": {},
                        "f:protocol": {}
                      }
                    },
                    "f:resources": {},
                    "f:securityContext": {
                      ".": {},
                      "f:allowPrivilegeEscalation": {},
                      "f:readOnlyRootFilesystem": {},
                      "f:runAsGroup": {},
                      "f:runAsUser": {}
                    },
                    "f:terminationMessagePath": {},
                    "f:terminationMessagePolicy": {},
                    "f:volumeMounts": {
                      ".": {},
                      "k:{\"mountPath\":\"/tmp\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {}
                      }
                    }
                  }
                },
                "f:dnsPolicy": {},
                "f:enableServiceLinks": {},
                "f:nodeSelector": {},
                "f:restartPolicy": {},
                "f:schedulerName": {},
                "f:securityContext": {
                  ".": {},
                  "f:seccompProfile": {
                    ".": {},
                    "f:type": {}
                  }
                },
                "f:serviceAccount": {},
                "f:serviceAccountName": {},
                "f:terminationGracePeriodSeconds": {},
                "f:tolerations": {},
                "f:volumes": {
                  ".": {},
                  "k:{\"name\":\"tmp-volume\"}": {
                    ".": {},
                    "f:emptyDir": {},
                    "f:name": {}
                  }
                }
              }
            }
          },
          {
            "manager": "Go-http-client",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-29T11:04:17Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:metadata": {
                "f:annotations": {
                  ".": {},
                  "f:cni.projectcalico.org/containerID": {},
                  "f:cni.projectcalico.org/podIP": {},
                  "f:cni.projectcalico.org/podIPs": {}
                }
              }
            },
            "subresource": "status"
          },
          {
            "manager": "kubelite",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-29T11:10:18Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:status": {
                "f:conditions": {
                  "k:{\"type\":\"ContainersReady\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  },
                  "k:{\"type\":\"Initialized\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  },
                  "k:{\"type\":\"Ready\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  }
                },
                "f:containerStatuses": {},
                "f:hostIP": {},
                "f:phase": {},
                "f:podIP": {},
                "f:podIPs": {
                  ".": {},
                  "k:{\"ip\":\"10.1.52.135\"}": {
                    ".": {},
                    "f:ip": {}
                  }
                },
                "f:startTime": {}
              }
            },
            "subresource": "status"
          }
        ]
      },
      "spec": {
        "volumes": [
          {
            "name": "tmp-volume",
            "emptyDir": {}
          },
          {
            "name": "kube-api-access-gxr47",
            "projected": {
              "sources": [
                {
                  "serviceAccountToken": {
                    "expirationSeconds": 3607,
                    "path": "token"
                  }
                },
                {
                  "configMap": {
                    "name": "kube-root-ca.crt",
                    "items": [
                      {
                        "key": "ca.crt",
                        "path": "ca.crt"
                      }
                    ]
                  }
                },
                {
                  "downwardAPI": {
                    "items": [
                      {
                        "path": "namespace",
                        "fieldRef": {
                          "apiVersion": "v1",
                          "fieldPath": "metadata.namespace"
                        }
                      }
                    ]
                  }
                }
              ],
              "defaultMode": 420
            }
          }
        ],
        "containers": [
          {
            "name": "dashboard-metrics-scraper",
            "image": "kubernetesui/metrics-scraper:v1.0.8",
            "ports": [
              {
                "containerPort": 8000,
                "protocol": "TCP"
              }
            ],
            "resources": {},
            "volumeMounts": [
              {
                "name": "tmp-volume",
                "mountPath": "/tmp"
              },
              {
                "name": "kube-api-access-gxr47",
                "readOnly": true,
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
              }
            ],
            "livenessProbe": {
              "httpGet": {
                "path": "/",
                "port": 8000,
                "scheme": "HTTP"
              },
              "initialDelaySeconds": 30,
              "timeoutSeconds": 30,
              "periodSeconds": 10,
              "successThreshold": 1,
              "failureThreshold": 3
            },
            "terminationMessagePath": "/dev/termination-log",
            "terminationMessagePolicy": "File",
            "imagePullPolicy": "IfNotPresent",
            "securityContext": {
              "runAsUser": 1001,
              "runAsGroup": 2001,
              "readOnlyRootFilesystem": true,
              "allowPrivilegeEscalation": false
            }
          }
        ],
        "restartPolicy": "Always",
        "terminationGracePeriodSeconds": 30,
        "dnsPolicy": "ClusterFirst",
        "nodeSelector": {
          "kubernetes.io/os": "linux"
        },
        "serviceAccountName": "kubernetes-dashboard",
        "serviceAccount": "kubernetes-dashboard",
        "nodeName": "vagrant",
        "securityContext": {
          "seccompProfile": {
            "type": "RuntimeDefault"
          }
        },
        "schedulerName": "default-scheduler",
        "tolerations": [
          {
            "key": "node-role.kubernetes.io/master",
            "effect": "NoSchedule"
          },
          {
            "key": "node.kubernetes.io/not-ready",
            "operator": "Exists",
            "effect": "NoExecute",
            "tolerationSeconds": 300
          },
          {
            "key": "node.kubernetes.io/unreachable",
            "operator": "Exists",
            "effect": "NoExecute",
            "tolerationSeconds": 300
          }
        ],
        "priority": 0,
        "enableServiceLinks": true,
        "preemptionPolicy": "PreemptLowerPriority"
      },
      "status": {
        "phase": "Running",
        "conditions": [
          {
            "type": "Initialized",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-29T10:35:00Z"
          },
          {
            "type": "Ready",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-29T11:04:45Z"
          },
          {
            "type": "ContainersReady",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-29T11:04:45Z"
          },
          {
            "type": "PodScheduled",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-29T10:34:52Z"
          }
        ],
        "hostIP": "10.0.2.15",
        "podIP": "10.1.52.135",
        "podIPs": [
          {
            "ip": "10.1.52.135"
          }
        ],
        "startTime": "2023-03-29T10:35:00Z",
        "containerStatuses": [
          {
            "name": "dashboard-metrics-scraper",
            "state": {
              "running": {
                "startedAt": "2023-03-29T11:04:25Z"
              }
            },
            "lastState": {
              "terminated": {
                "exitCode": 255,
                "reason": "Unknown",
                "startedAt": "2023-03-29T10:37:31Z",
                "finishedAt": "2023-03-29T11:02:54Z",
                "containerID": "containerd://aac493c5c5e9743f9d672b78e0d7455aedce4f36805ffed2fb89a9fc8f9597a4"
              }
            },
            "ready": true,
            "restartCount": 1,
            "image": "docker.io/kubernetesui/metrics-scraper:v1.0.8",
            "imageID": "docker.io/kubernetesui/metrics-scraper@sha256:76049887f07a0476dc93efc2d3569b9529bf982b22d29f356092ce206e98765c",
            "containerID": "containerd://a5fb7a52c790e1a3f57f77ff60987d6a4634b89939f56f44858d7eb74f07d555",
            "started": true
          }
        ],
        "qosClass": "BestEffort"
      }
    },
    {
      "metadata": {
        "name": "calico-kube-controllers-c4464c45-tt4pm",
        "generateName": "calico-kube-controllers-c4464c45-",
        "namespace": "kube-system",
        "uid": "8e691309-5f54-4139-9f37-ea1b83d33427",
        "resourceVersion": "4609",
        "creationTimestamp": "2023-03-29T10:25:07Z",
        "labels": {
          "k8s-app": "calico-kube-controllers",
          "pod-template-hash": "c4464c45"
        },
        "annotations": {
          "cni.projectcalico.org/containerID": "0e3ee88dffad36ea25f315c50f00e468a998118f6248962b456516c34af7b00a",
          "cni.projectcalico.org/podIP": "10.1.52.134/32",
          "cni.projectcalico.org/podIPs": "10.1.52.134/32",
          "kubectl.kubernetes.io/restartedAt": "2023-03-29T10:25:03Z"
        },
        "ownerReferences": [
          {
            "apiVersion": "apps/v1",
            "kind": "ReplicaSet",
            "name": "calico-kube-controllers-c4464c45",
            "uid": "1aa06344-4a4e-44f8-921b-c870f32a403c",
            "controller": true,
            "blockOwnerDeletion": true
          }
        ],
        "managedFields": [
          {
            "manager": "kubelite",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-29T10:25:07Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:metadata": {
                "f:annotations": {
                  ".": {},
                  "f:kubectl.kubernetes.io/restartedAt": {}
                },
                "f:generateName": {},
                "f:labels": {
                  ".": {},
                  "f:k8s-app": {},
                  "f:pod-template-hash": {}
                },
                "f:ownerReferences": {
                  ".": {},
                  "k:{\"uid\":\"1aa06344-4a4e-44f8-921b-c870f32a403c\"}": {}
                }
              },
              "f:spec": {
                "f:containers": {
                  "k:{\"name\":\"calico-kube-controllers\"}": {
                    ".": {},
                    "f:env": {
                      ".": {},
                      "k:{\"name\":\"DATASTORE_TYPE\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"ENABLED_CONTROLLERS\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      }
                    },
                    "f:image": {},
                    "f:imagePullPolicy": {},
                    "f:livenessProbe": {
                      ".": {},
                      "f:exec": {
                        ".": {},
                        "f:command": {}
                      },
                      "f:failureThreshold": {},
                      "f:initialDelaySeconds": {},
                      "f:periodSeconds": {},
                      "f:successThreshold": {},
                      "f:timeoutSeconds": {}
                    },
                    "f:name": {},
                    "f:readinessProbe": {
                      ".": {},
                      "f:exec": {
                        ".": {},
                        "f:command": {}
                      },
                      "f:failureThreshold": {},
                      "f:periodSeconds": {},
                      "f:successThreshold": {},
                      "f:timeoutSeconds": {}
                    },
                    "f:resources": {},
                    "f:terminationMessagePath": {},
                    "f:terminationMessagePolicy": {}
                  }
                },
                "f:dnsPolicy": {},
                "f:enableServiceLinks": {},
                "f:nodeSelector": {},
                "f:priorityClassName": {},
                "f:restartPolicy": {},
                "f:schedulerName": {},
                "f:securityContext": {},
                "f:serviceAccount": {},
                "f:serviceAccountName": {},
                "f:terminationGracePeriodSeconds": {},
                "f:tolerations": {}
              }
            }
          },
          {
            "manager": "Go-http-client",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-29T11:04:16Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:metadata": {
                "f:annotations": {
                  "f:cni.projectcalico.org/containerID": {},
                  "f:cni.projectcalico.org/podIP": {},
                  "f:cni.projectcalico.org/podIPs": {}
                }
              }
            },
            "subresource": "status"
          },
          {
            "manager": "kubelite",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-30T19:17:08Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:status": {
                "f:conditions": {
                  ".": {},
                  "k:{\"type\":\"ContainersReady\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  },
                  "k:{\"type\":\"Initialized\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  },
                  "k:{\"type\":\"PodScheduled\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:message": {},
                    "f:reason": {},
                    "f:status": {},
                    "f:type": {}
                  },
                  "k:{\"type\":\"Ready\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  }
                },
                "f:containerStatuses": {},
                "f:hostIP": {},
                "f:phase": {},
                "f:podIP": {},
                "f:podIPs": {
                  ".": {},
                  "k:{\"ip\":\"10.1.52.134\"}": {
                    ".": {},
                    "f:ip": {}
                  }
                },
                "f:startTime": {}
              }
            },
            "subresource": "status"
          }
        ]
      },
      "spec": {
        "volumes": [
          {
            "name": "kube-api-access-4g59x",
            "projected": {
              "sources": [
                {
                  "serviceAccountToken": {
                    "expirationSeconds": 3607,
                    "path": "token"
                  }
                },
                {
                  "configMap": {
                    "name": "kube-root-ca.crt",
                    "items": [
                      {
                        "key": "ca.crt",
                        "path": "ca.crt"
                      }
                    ]
                  }
                },
                {
                  "downwardAPI": {
                    "items": [
                      {
                        "path": "namespace",
                        "fieldRef": {
                          "apiVersion": "v1",
                          "fieldPath": "metadata.namespace"
                        }
                      }
                    ]
                  }
                }
              ],
              "defaultMode": 420
            }
          }
        ],
        "containers": [
          {
            "name": "calico-kube-controllers",
            "image": "docker.io/calico/kube-controllers:v3.23.5",
            "env": [
              {
                "name": "ENABLED_CONTROLLERS",
                "value": "node"
              },
              {
                "name": "DATASTORE_TYPE",
                "value": "kubernetes"
              }
            ],
            "resources": {},
            "volumeMounts": [
              {
                "name": "kube-api-access-4g59x",
                "readOnly": true,
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
              }
            ],
            "livenessProbe": {
              "exec": {
                "command": [
                  "/usr/bin/check-status",
                  "-l"
                ]
              },
              "initialDelaySeconds": 10,
              "timeoutSeconds": 10,
              "periodSeconds": 10,
              "successThreshold": 1,
              "failureThreshold": 6
            },
            "readinessProbe": {
              "exec": {
                "command": [
                  "/usr/bin/check-status",
                  "-r"
                ]
              },
              "timeoutSeconds": 1,
              "periodSeconds": 10,
              "successThreshold": 1,
              "failureThreshold": 3
            },
            "terminationMessagePath": "/dev/termination-log",
            "terminationMessagePolicy": "File",
            "imagePullPolicy": "IfNotPresent"
          }
        ],
        "restartPolicy": "Always",
        "terminationGracePeriodSeconds": 30,
        "dnsPolicy": "ClusterFirst",
        "nodeSelector": {
          "kubernetes.io/os": "linux"
        },
        "serviceAccountName": "calico-kube-controllers",
        "serviceAccount": "calico-kube-controllers",
        "nodeName": "vagrant",
        "securityContext": {},
        "schedulerName": "default-scheduler",
        "tolerations": [
          {
            "key": "CriticalAddonsOnly",
            "operator": "Exists"
          },
          {
            "key": "node-role.kubernetes.io/master",
            "effect": "NoSchedule"
          },
          {
            "key": "node.kubernetes.io/not-ready",
            "operator": "Exists",
            "effect": "NoExecute",
            "tolerationSeconds": 300
          },
          {
            "key": "node.kubernetes.io/unreachable",
            "operator": "Exists",
            "effect": "NoExecute",
            "tolerationSeconds": 300
          }
        ],
        "priorityClassName": "system-cluster-critical",
        "priority": 2000000000,
        "enableServiceLinks": true,
        "preemptionPolicy": "PreemptLowerPriority"
      },
      "status": {
        "phase": "Running",
        "conditions": [
          {
            "type": "Initialized",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-29T10:25:29Z"
          },
          {
            "type": "Ready",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-30T19:17:00Z"
          },
          {
            "type": "ContainersReady",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-30T19:17:00Z"
          },
          {
            "type": "PodScheduled",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-29T10:25:29Z"
          }
        ],
        "hostIP": "10.0.2.15",
        "podIP": "10.1.52.134",
        "podIPs": [
          {
            "ip": "10.1.52.134"
          }
        ],
        "startTime": "2023-03-29T10:25:29Z",
        "containerStatuses": [
          {
            "name": "calico-kube-controllers",
            "state": {
              "running": {
                "startedAt": "2023-03-29T11:04:54Z"
              }
            },
            "lastState": {
              "terminated": {
                "exitCode": 1,
                "reason": "Error",
                "startedAt": "2023-03-29T11:04:25Z",
                "finishedAt": "2023-03-29T11:04:37Z",
                "containerID": "containerd://55b9ce754267e708a51d2aa91a507212dbd132cf0b7d5148ec3f2a126c25f7eb"
              }
            },
            "ready": true,
            "restartCount": 2,
            "image": "docker.io/calico/kube-controllers:v3.23.5",
            "imageID": "docker.io/calico/kube-controllers@sha256:58cc91c551e9e941a752e205eefed1c8da56f97a51e054b3d341b67bb7bf27eb",
            "containerID": "containerd://7884957c2adc73fb39f0023c5b0fb0ba71b1e0ebb2a029b2a25b2a433f99d42a",
            "started": true
          }
        ],
        "qosClass": "BestEffort"
      }
    },
    {
      "metadata": {
        "name": "metrics-server-6f754f88d-44ngt",
        "generateName": "metrics-server-6f754f88d-",
        "namespace": "kube-system",
        "uid": "974dc2ba-023a-4bfa-bc01-c18a9c7e8a2d",
        "resourceVersion": "4611",
        "creationTimestamp": "2023-03-29T10:33:18Z",
        "labels": {
          "k8s-app": "metrics-server",
          "pod-template-hash": "6f754f88d"
        },
        "annotations": {
          "cni.projectcalico.org/containerID": "35a9fec84e374d12ff1edd51d82b76c140fcbf179c9b10a1d51aa17e349b9240",
          "cni.projectcalico.org/podIP": "10.1.52.133/32",
          "cni.projectcalico.org/podIPs": "10.1.52.133/32"
        },
        "ownerReferences": [
          {
            "apiVersion": "apps/v1",
            "kind": "ReplicaSet",
            "name": "metrics-server-6f754f88d",
            "uid": "31691995-94be-4959-853f-2952cfde8829",
            "controller": true,
            "blockOwnerDeletion": true
          }
        ],
        "managedFields": [
          {
            "manager": "kubelite",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-29T10:33:18Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:metadata": {
                "f:generateName": {},
                "f:labels": {
                  ".": {},
                  "f:k8s-app": {},
                  "f:pod-template-hash": {}
                },
                "f:ownerReferences": {
                  ".": {},
                  "k:{\"uid\":\"31691995-94be-4959-853f-2952cfde8829\"}": {}
                }
              },
              "f:spec": {
                "f:containers": {
                  "k:{\"name\":\"metrics-server\"}": {
                    ".": {},
                    "f:args": {},
                    "f:image": {},
                    "f:imagePullPolicy": {},
                    "f:livenessProbe": {
                      ".": {},
                      "f:failureThreshold": {},
                      "f:httpGet": {
                        ".": {},
                        "f:path": {},
                        "f:port": {},
                        "f:scheme": {}
                      },
                      "f:periodSeconds": {},
                      "f:successThreshold": {},
                      "f:timeoutSeconds": {}
                    },
                    "f:name": {},
                    "f:ports": {
                      ".": {},
                      "k:{\"containerPort\":4443,\"protocol\":\"TCP\"}": {
                        ".": {},
                        "f:containerPort": {},
                        "f:name": {},
                        "f:protocol": {}
                      }
                    },
                    "f:readinessProbe": {
                      ".": {},
                      "f:failureThreshold": {},
                      "f:httpGet": {
                        ".": {},
                        "f:path": {},
                        "f:port": {},
                        "f:scheme": {}
                      },
                      "f:initialDelaySeconds": {},
                      "f:periodSeconds": {},
                      "f:successThreshold": {},
                      "f:timeoutSeconds": {}
                    },
                    "f:resources": {
                      ".": {},
                      "f:requests": {
                        ".": {},
                        "f:cpu": {},
                        "f:memory": {}
                      }
                    },
                    "f:securityContext": {
                      ".": {},
                      "f:readOnlyRootFilesystem": {},
                      "f:runAsNonRoot": {},
                      "f:runAsUser": {}
                    },
                    "f:terminationMessagePath": {},
                    "f:terminationMessagePolicy": {},
                    "f:volumeMounts": {
                      ".": {},
                      "k:{\"mountPath\":\"/tmp\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {}
                      }
                    }
                  }
                },
                "f:dnsPolicy": {},
                "f:enableServiceLinks": {},
                "f:nodeSelector": {},
                "f:priorityClassName": {},
                "f:restartPolicy": {},
                "f:schedulerName": {},
                "f:securityContext": {},
                "f:serviceAccount": {},
                "f:serviceAccountName": {},
                "f:terminationGracePeriodSeconds": {},
                "f:volumes": {
                  ".": {},
                  "k:{\"name\":\"tmp-dir\"}": {
                    ".": {},
                    "f:emptyDir": {},
                    "f:name": {}
                  }
                }
              }
            }
          },
          {
            "manager": "Go-http-client",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-29T11:04:16Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:metadata": {
                "f:annotations": {
                  ".": {},
                  "f:cni.projectcalico.org/containerID": {},
                  "f:cni.projectcalico.org/podIP": {},
                  "f:cni.projectcalico.org/podIPs": {}
                }
              }
            },
            "subresource": "status"
          },
          {
            "manager": "kubelite",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-30T19:17:08Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:status": {
                "f:conditions": {
                  "k:{\"type\":\"ContainersReady\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  },
                  "k:{\"type\":\"Initialized\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  },
                  "k:{\"type\":\"Ready\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  }
                },
                "f:containerStatuses": {},
                "f:hostIP": {},
                "f:phase": {},
                "f:podIP": {},
                "f:podIPs": {
                  ".": {},
                  "k:{\"ip\":\"10.1.52.133\"}": {
                    ".": {},
                    "f:ip": {}
                  }
                },
                "f:startTime": {}
              }
            },
            "subresource": "status"
          }
        ]
      },
      "spec": {
        "volumes": [
          {
            "name": "tmp-dir",
            "emptyDir": {}
          },
          {
            "name": "kube-api-access-qzp9j",
            "projected": {
              "sources": [
                {
                  "serviceAccountToken": {
                    "expirationSeconds": 3607,
                    "path": "token"
                  }
                },
                {
                  "configMap": {
                    "name": "kube-root-ca.crt",
                    "items": [
                      {
                        "key": "ca.crt",
                        "path": "ca.crt"
                      }
                    ]
                  }
                },
                {
                  "downwardAPI": {
                    "items": [
                      {
                        "path": "namespace",
                        "fieldRef": {
                          "apiVersion": "v1",
                          "fieldPath": "metadata.namespace"
                        }
                      }
                    ]
                  }
                }
              ],
              "defaultMode": 420
            }
          }
        ],
        "containers": [
          {
            "name": "metrics-server",
            "image": "registry.k8s.io/metrics-server/metrics-server:v0.5.2",
            "args": [
              "--cert-dir=/tmp",
              "--secure-port=4443",
              "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
              "--kubelet-use-node-status-port",
              "--metric-resolution=15s",
              "--kubelet-insecure-tls"
            ],
            "ports": [
              {
                "name": "https",
                "containerPort": 4443,
                "protocol": "TCP"
              }
            ],
            "resources": {
              "requests": {
                "cpu": "100m",
                "memory": "200Mi"
              }
            },
            "volumeMounts": [
              {
                "name": "tmp-dir",
                "mountPath": "/tmp"
              },
              {
                "name": "kube-api-access-qzp9j",
                "readOnly": true,
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
              }
            ],
            "livenessProbe": {
              "httpGet": {
                "path": "/livez",
                "port": "https",
                "scheme": "HTTPS"
              },
              "timeoutSeconds": 1,
              "periodSeconds": 10,
              "successThreshold": 1,
              "failureThreshold": 3
            },
            "readinessProbe": {
              "httpGet": {
                "path": "/readyz",
                "port": "https",
                "scheme": "HTTPS"
              },
              "initialDelaySeconds": 20,
              "timeoutSeconds": 1,
              "periodSeconds": 10,
              "successThreshold": 1,
              "failureThreshold": 3
            },
            "terminationMessagePath": "/dev/termination-log",
            "terminationMessagePolicy": "File",
            "imagePullPolicy": "IfNotPresent",
            "securityContext": {
              "runAsUser": 1000,
              "runAsNonRoot": true,
              "readOnlyRootFilesystem": true
            }
          }
        ],
        "restartPolicy": "Always",
        "terminationGracePeriodSeconds": 30,
        "dnsPolicy": "ClusterFirst",
        "nodeSelector": {
          "kubernetes.io/arch": "amd64",
          "kubernetes.io/os": "linux"
        },
        "serviceAccountName": "metrics-server",
        "serviceAccount": "metrics-server",
        "nodeName": "vagrant",
        "securityContext": {},
        "schedulerName": "default-scheduler",
        "tolerations": [
          {
            "key": "node.kubernetes.io/not-ready",
            "operator": "Exists",
            "effect": "NoExecute",
            "tolerationSeconds": 300
          },
          {
            "key": "node.kubernetes.io/unreachable",
            "operator": "Exists",
            "effect": "NoExecute",
            "tolerationSeconds": 300
          }
        ],
        "priorityClassName": "system-cluster-critical",
        "priority": 2000000000,
        "enableServiceLinks": true,
        "preemptionPolicy": "PreemptLowerPriority"
      },
      "status": {
        "phase": "Running",
        "conditions": [
          {
            "type": "Initialized",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-29T10:33:19Z"
          },
          {
            "type": "Ready",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-30T19:17:02Z"
          },
          {
            "type": "ContainersReady",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-30T19:17:02Z"
          },
          {
            "type": "PodScheduled",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-29T10:33:19Z"
          }
        ],
        "hostIP": "10.0.2.15",
        "podIP": "10.1.52.133",
        "podIPs": [
          {
            "ip": "10.1.52.133"
          }
        ],
        "startTime": "2023-03-29T10:33:19Z",
        "containerStatuses": [
          {
            "name": "metrics-server",
            "state": {
              "running": {
                "startedAt": "2023-03-30T05:46:27Z"
              }
            },
            "lastState": {
              "terminated": {
                "exitCode": 0,
                "reason": "Completed",
                "startedAt": "2023-03-30T05:38:03Z",
                "finishedAt": "2023-03-30T05:46:20Z",
                "containerID": "containerd://d6a9df74e0480f2ca9b36d1ac502c43ae6d59335f4f21592da806a9c5c691741"
              }
            },
            "ready": true,
            "restartCount": 4,
            "image": "registry.k8s.io/metrics-server/metrics-server:v0.5.2",
            "imageID": "registry.k8s.io/metrics-server/metrics-server@sha256:6385aec64bb97040a5e692947107b81e178555c7a5b71caa90d733e4130efc10",
            "containerID": "containerd://1b98b47e27b519b058929e46d9d697c99108d0b4b922efa513c674215f6246b2",
            "started": true
          }
        ],
        "qosClass": "Burstable"
      }
    },
    {
      "metadata": {
        "name": "kubernetes-dashboard-dc96f9fc-7zzvr",
        "generateName": "kubernetes-dashboard-dc96f9fc-",
        "namespace": "kube-system",
        "uid": "2514540e-1282-4a34-aab4-c211b5700580",
        "resourceVersion": "4615",
        "creationTimestamp": "2023-03-29T10:34:51Z",
        "labels": {
          "k8s-app": "kubernetes-dashboard",
          "pod-template-hash": "dc96f9fc"
        },
        "annotations": {
          "cni.projectcalico.org/containerID": "bcebf60a7ab7556c52f254810c79b4a21ef21eb0e52606ad6fc9ac2d2f1f7606",
          "cni.projectcalico.org/podIP": "10.1.52.136/32",
          "cni.projectcalico.org/podIPs": "10.1.52.136/32"
        },
        "ownerReferences": [
          {
            "apiVersion": "apps/v1",
            "kind": "ReplicaSet",
            "name": "kubernetes-dashboard-dc96f9fc",
            "uid": "766bcb02-a779-44b8-be0c-b11519034fda",
            "controller": true,
            "blockOwnerDeletion": true
          }
        ],
        "managedFields": [
          {
            "manager": "kubelite",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-29T10:34:51Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:metadata": {
                "f:generateName": {},
                "f:labels": {
                  ".": {},
                  "f:k8s-app": {},
                  "f:pod-template-hash": {}
                },
                "f:ownerReferences": {
                  ".": {},
                  "k:{\"uid\":\"766bcb02-a779-44b8-be0c-b11519034fda\"}": {}
                }
              },
              "f:spec": {
                "f:containers": {
                  "k:{\"name\":\"kubernetes-dashboard\"}": {
                    ".": {},
                    "f:args": {},
                    "f:image": {},
                    "f:imagePullPolicy": {},
                    "f:livenessProbe": {
                      ".": {},
                      "f:failureThreshold": {},
                      "f:httpGet": {
                        ".": {},
                        "f:path": {},
                        "f:port": {},
                        "f:scheme": {}
                      },
                      "f:initialDelaySeconds": {},
                      "f:periodSeconds": {},
                      "f:successThreshold": {},
                      "f:timeoutSeconds": {}
                    },
                    "f:name": {},
                    "f:ports": {
                      ".": {},
                      "k:{\"containerPort\":8443,\"protocol\":\"TCP\"}": {
                        ".": {},
                        "f:containerPort": {},
                        "f:protocol": {}
                      }
                    },
                    "f:resources": {},
                    "f:securityContext": {
                      ".": {},
                      "f:allowPrivilegeEscalation": {},
                      "f:readOnlyRootFilesystem": {},
                      "f:runAsGroup": {},
                      "f:runAsUser": {}
                    },
                    "f:terminationMessagePath": {},
                    "f:terminationMessagePolicy": {},
                    "f:volumeMounts": {
                      ".": {},
                      "k:{\"mountPath\":\"/certs\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {}
                      },
                      "k:{\"mountPath\":\"/tmp\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {}
                      }
                    }
                  }
                },
                "f:dnsPolicy": {},
                "f:enableServiceLinks": {},
                "f:nodeSelector": {},
                "f:restartPolicy": {},
                "f:schedulerName": {},
                "f:securityContext": {
                  ".": {},
                  "f:seccompProfile": {
                    ".": {},
                    "f:type": {}
                  }
                },
                "f:serviceAccount": {},
                "f:serviceAccountName": {},
                "f:terminationGracePeriodSeconds": {},
                "f:tolerations": {},
                "f:volumes": {
                  ".": {},
                  "k:{\"name\":\"kubernetes-dashboard-certs\"}": {
                    ".": {},
                    "f:name": {},
                    "f:secret": {
                      ".": {},
                      "f:defaultMode": {},
                      "f:secretName": {}
                    }
                  },
                  "k:{\"name\":\"tmp-volume\"}": {
                    ".": {},
                    "f:emptyDir": {},
                    "f:name": {}
                  }
                }
              }
            }
          },
          {
            "manager": "Go-http-client",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-29T11:04:18Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:metadata": {
                "f:annotations": {
                  ".": {},
                  "f:cni.projectcalico.org/containerID": {},
                  "f:cni.projectcalico.org/podIP": {},
                  "f:cni.projectcalico.org/podIPs": {}
                }
              }
            },
            "subresource": "status"
          },
          {
            "manager": "kubelite",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-30T19:17:08Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:status": {
                "f:conditions": {
                  "k:{\"type\":\"ContainersReady\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  },
                  "k:{\"type\":\"Initialized\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  },
                  "k:{\"type\":\"Ready\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  }
                },
                "f:containerStatuses": {},
                "f:hostIP": {},
                "f:phase": {},
                "f:podIP": {},
                "f:podIPs": {
                  ".": {},
                  "k:{\"ip\":\"10.1.52.136\"}": {
                    ".": {},
                    "f:ip": {}
                  }
                },
                "f:startTime": {}
              }
            },
            "subresource": "status"
          }
        ]
      },
      "spec": {
        "volumes": [
          {
            "name": "kubernetes-dashboard-certs",
            "secret": {
              "secretName": "kubernetes-dashboard-certs",
              "defaultMode": 420
            }
          },
          {
            "name": "tmp-volume",
            "emptyDir": {}
          },
          {
            "name": "kube-api-access-qrz8x",
            "projected": {
              "sources": [
                {
                  "serviceAccountToken": {
                    "expirationSeconds": 3607,
                    "path": "token"
                  }
                },
                {
                  "configMap": {
                    "name": "kube-root-ca.crt",
                    "items": [
                      {
                        "key": "ca.crt",
                        "path": "ca.crt"
                      }
                    ]
                  }
                },
                {
                  "downwardAPI": {
                    "items": [
                      {
                        "path": "namespace",
                        "fieldRef": {
                          "apiVersion": "v1",
                          "fieldPath": "metadata.namespace"
                        }
                      }
                    ]
                  }
                }
              ],
              "defaultMode": 420
            }
          }
        ],
        "containers": [
          {
            "name": "kubernetes-dashboard",
            "image": "kubernetesui/dashboard:v2.7.0",
            "args": [
              "--auto-generate-certificates",
              "--namespace=kube-system"
            ],
            "ports": [
              {
                "containerPort": 8443,
                "protocol": "TCP"
              }
            ],
            "resources": {},
            "volumeMounts": [
              {
                "name": "kubernetes-dashboard-certs",
                "mountPath": "/certs"
              },
              {
                "name": "tmp-volume",
                "mountPath": "/tmp"
              },
              {
                "name": "kube-api-access-qrz8x",
                "readOnly": true,
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
              }
            ],
            "livenessProbe": {
              "httpGet": {
                "path": "/",
                "port": 8443,
                "scheme": "HTTPS"
              },
              "initialDelaySeconds": 30,
              "timeoutSeconds": 30,
              "periodSeconds": 10,
              "successThreshold": 1,
              "failureThreshold": 3
            },
            "terminationMessagePath": "/dev/termination-log",
            "terminationMessagePolicy": "File",
            "imagePullPolicy": "IfNotPresent",
            "securityContext": {
              "runAsUser": 1001,
              "runAsGroup": 2001,
              "readOnlyRootFilesystem": true,
              "allowPrivilegeEscalation": false
            }
          }
        ],
        "restartPolicy": "Always",
        "terminationGracePeriodSeconds": 30,
        "dnsPolicy": "ClusterFirst",
        "nodeSelector": {
          "kubernetes.io/os": "linux"
        },
        "serviceAccountName": "kubernetes-dashboard",
        "serviceAccount": "kubernetes-dashboard",
        "nodeName": "vagrant",
        "securityContext": {
          "seccompProfile": {
            "type": "RuntimeDefault"
          }
        },
        "schedulerName": "default-scheduler",
        "tolerations": [
          {
            "key": "node-role.kubernetes.io/master",
            "effect": "NoSchedule"
          },
          {
            "key": "node.kubernetes.io/not-ready",
            "operator": "Exists",
            "effect": "NoExecute",
            "tolerationSeconds": 300
          },
          {
            "key": "node.kubernetes.io/unreachable",
            "operator": "Exists",
            "effect": "NoExecute",
            "tolerationSeconds": 300
          }
        ],
        "priority": 0,
        "enableServiceLinks": true,
        "preemptionPolicy": "PreemptLowerPriority"
      },
      "status": {
        "phase": "Running",
        "conditions": [
          {
            "type": "Initialized",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-29T10:34:55Z"
          },
          {
            "type": "Ready",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-30T19:17:07Z"
          },
          {
            "type": "ContainersReady",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-30T19:17:07Z"
          },
          {
            "type": "PodScheduled",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-29T10:34:52Z"
          }
        ],
        "hostIP": "10.0.2.15",
        "podIP": "10.1.52.136",
        "podIPs": [
          {
            "ip": "10.1.52.136"
          }
        ],
        "startTime": "2023-03-29T10:34:55Z",
        "containerStatuses": [
          {
            "name": "kubernetes-dashboard",
            "state": {
              "running": {
                "startedAt": "2023-03-30T19:17:00Z"
              }
            },
            "lastState": {
              "terminated": {
                "exitCode": 2,
                "reason": "Error",
                "startedAt": "2023-03-29T11:04:24Z",
                "finishedAt": "2023-03-30T19:16:04Z",
                "containerID": "containerd://2054e09b884d496e1e6b4240430c2a9e5d36eab4ecc998953c83bb20e623c126"
              }
            },
            "ready": true,
            "restartCount": 2,
            "image": "docker.io/kubernetesui/dashboard:v2.7.0",
            "imageID": "docker.io/kubernetesui/dashboard@sha256:2e500d29e9d5f4a086b908eb8dfe7ecac57d2ab09d65b24f588b1d449841ef93",
            "containerID": "containerd://49e47fc763016f036f9a4f2275a24992e697d76576a0e2276e256ec5de51be56",
            "started": true
          }
        ],
        "qosClass": "BestEffort"
      }
    },
    {
      "metadata": {
        "name": "calico-node-4qm6c",
        "generateName": "calico-node-",
        "namespace": "kube-system",
        "uid": "63fd7cae-9fef-4f72-9f64-764f834ab122",
        "resourceVersion": "4619",
        "creationTimestamp": "2023-03-29T10:25:06Z",
        "labels": {
          "controller-revision-hash": "68dc7645b9",
          "k8s-app": "calico-node",
          "pod-template-generation": "2"
        },
        "annotations": {
          "kubectl.kubernetes.io/restartedAt": "2023-03-29T10:25:02Z"
        },
        "ownerReferences": [
          {
            "apiVersion": "apps/v1",
            "kind": "DaemonSet",
            "name": "calico-node",
            "uid": "8d3d2b93-2de5-4220-9823-d7f7953d3f92",
            "controller": true,
            "blockOwnerDeletion": true
          }
        ],
        "managedFields": [
          {
            "manager": "kubelite",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-29T10:25:06Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:metadata": {
                "f:annotations": {
                  ".": {},
                  "f:kubectl.kubernetes.io/restartedAt": {}
                },
                "f:generateName": {},
                "f:labels": {
                  ".": {},
                  "f:controller-revision-hash": {},
                  "f:k8s-app": {},
                  "f:pod-template-generation": {}
                },
                "f:ownerReferences": {
                  ".": {},
                  "k:{\"uid\":\"8d3d2b93-2de5-4220-9823-d7f7953d3f92\"}": {}
                }
              },
              "f:spec": {
                "f:affinity": {
                  ".": {},
                  "f:nodeAffinity": {
                    ".": {},
                    "f:requiredDuringSchedulingIgnoredDuringExecution": {}
                  }
                },
                "f:containers": {
                  "k:{\"name\":\"calico-node\"}": {
                    ".": {},
                    "f:env": {
                      ".": {},
                      "k:{\"name\":\"CALICO_DISABLE_FILE_LOGGING\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"CALICO_IPV4POOL_CIDR\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"CALICO_IPV4POOL_VXLAN\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"CALICO_IPV6POOL_VXLAN\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"CALICO_NETWORKING_BACKEND\"}": {
                        ".": {},
                        "f:name": {},
                        "f:valueFrom": {
                          ".": {},
                          "f:configMapKeyRef": {}
                        }
                      },
                      "k:{\"name\":\"CLUSTER_TYPE\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"DATASTORE_TYPE\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"FELIX_DEFAULTENDPOINTTOHOSTACTION\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"FELIX_HEALTHENABLED\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"FELIX_IPINIPMTU\"}": {
                        ".": {},
                        "f:name": {},
                        "f:valueFrom": {
                          ".": {},
                          "f:configMapKeyRef": {}
                        }
                      },
                      "k:{\"name\":\"FELIX_IPV6SUPPORT\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"FELIX_VXLANMTU\"}": {
                        ".": {},
                        "f:name": {},
                        "f:valueFrom": {
                          ".": {},
                          "f:configMapKeyRef": {}
                        }
                      },
                      "k:{\"name\":\"FELIX_WIREGUARDMTU\"}": {
                        ".": {},
                        "f:name": {},
                        "f:valueFrom": {
                          ".": {},
                          "f:configMapKeyRef": {}
                        }
                      },
                      "k:{\"name\":\"IP\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"IP_AUTODETECTION_METHOD\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"NODENAME\"}": {
                        ".": {},
                        "f:name": {},
                        "f:valueFrom": {
                          ".": {},
                          "f:fieldRef": {}
                        }
                      },
                      "k:{\"name\":\"WAIT_FOR_DATASTORE\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      }
                    },
                    "f:envFrom": {},
                    "f:image": {},
                    "f:imagePullPolicy": {},
                    "f:lifecycle": {
                      ".": {},
                      "f:preStop": {
                        ".": {},
                        "f:exec": {
                          ".": {},
                          "f:command": {}
                        }
                      }
                    },
                    "f:livenessProbe": {
                      ".": {},
                      "f:exec": {
                        ".": {},
                        "f:command": {}
                      },
                      "f:failureThreshold": {},
                      "f:initialDelaySeconds": {},
                      "f:periodSeconds": {},
                      "f:successThreshold": {},
                      "f:timeoutSeconds": {}
                    },
                    "f:name": {},
                    "f:readinessProbe": {
                      ".": {},
                      "f:exec": {
                        ".": {},
                        "f:command": {}
                      },
                      "f:failureThreshold": {},
                      "f:periodSeconds": {},
                      "f:successThreshold": {},
                      "f:timeoutSeconds": {}
                    },
                    "f:resources": {
                      ".": {},
                      "f:requests": {
                        ".": {},
                        "f:cpu": {}
                      }
                    },
                    "f:securityContext": {
                      ".": {},
                      "f:privileged": {}
                    },
                    "f:terminationMessagePath": {},
                    "f:terminationMessagePolicy": {},
                    "f:volumeMounts": {
                      ".": {},
                      "k:{\"mountPath\":\"/host/etc/cni/net.d\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {}
                      },
                      "k:{\"mountPath\":\"/lib/modules\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {},
                        "f:readOnly": {}
                      },
                      "k:{\"mountPath\":\"/run/xtables.lock\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {}
                      },
                      "k:{\"mountPath\":\"/var/lib/calico\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {}
                      },
                      "k:{\"mountPath\":\"/var/log/calico/cni\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {},
                        "f:readOnly": {}
                      },
                      "k:{\"mountPath\":\"/var/run/calico\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {}
                      },
                      "k:{\"mountPath\":\"/var/run/nodeagent\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {}
                      }
                    }
                  }
                },
                "f:dnsPolicy": {},
                "f:enableServiceLinks": {},
                "f:hostNetwork": {},
                "f:initContainers": {
                  ".": {},
                  "k:{\"name\":\"install-cni\"}": {
                    ".": {},
                    "f:command": {},
                    "f:env": {
                      ".": {},
                      "k:{\"name\":\"CNI_CONF_NAME\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"CNI_MTU\"}": {
                        ".": {},
                        "f:name": {},
                        "f:valueFrom": {
                          ".": {},
                          "f:configMapKeyRef": {}
                        }
                      },
                      "k:{\"name\":\"CNI_NETWORK_CONFIG\"}": {
                        ".": {},
                        "f:name": {},
                        "f:valueFrom": {
                          ".": {},
                          "f:configMapKeyRef": {}
                        }
                      },
                      "k:{\"name\":\"CNI_NET_DIR\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      },
                      "k:{\"name\":\"KUBERNETES_NODE_NAME\"}": {
                        ".": {},
                        "f:name": {},
                        "f:valueFrom": {
                          ".": {},
                          "f:fieldRef": {}
                        }
                      },
                      "k:{\"name\":\"SLEEP\"}": {
                        ".": {},
                        "f:name": {},
                        "f:value": {}
                      }
                    },
                    "f:envFrom": {},
                    "f:image": {},
                    "f:imagePullPolicy": {},
                    "f:name": {},
                    "f:resources": {},
                    "f:securityContext": {
                      ".": {},
                      "f:privileged": {}
                    },
                    "f:terminationMessagePath": {},
                    "f:terminationMessagePolicy": {},
                    "f:volumeMounts": {
                      ".": {},
                      "k:{\"mountPath\":\"/host/etc/cni/net.d\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {}
                      },
                      "k:{\"mountPath\":\"/host/opt/cni/bin\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {}
                      }
                    }
                  },
                  "k:{\"name\":\"upgrade-ipam\"}": {
                    ".": {},
                    "f:command": {},
                    "f:env": {
                      ".": {},
                      "k:{\"name\":\"CALICO_NETWORKING_BACKEND\"}": {
                        ".": {},
                        "f:name": {},
                        "f:valueFrom": {
                          ".": {},
                          "f:configMapKeyRef": {}
                        }
                      },
                      "k:{\"name\":\"KUBERNETES_NODE_NAME\"}": {
                        ".": {},
                        "f:name": {},
                        "f:valueFrom": {
                          ".": {},
                          "f:fieldRef": {}
                        }
                      }
                    },
                    "f:envFrom": {},
                    "f:image": {},
                    "f:imagePullPolicy": {},
                    "f:name": {},
                    "f:resources": {},
                    "f:securityContext": {
                      ".": {},
                      "f:privileged": {}
                    },
                    "f:terminationMessagePath": {},
                    "f:terminationMessagePolicy": {},
                    "f:volumeMounts": {
                      ".": {},
                      "k:{\"mountPath\":\"/host/opt/cni/bin\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {}
                      },
                      "k:{\"mountPath\":\"/var/lib/cni/networks\"}": {
                        ".": {},
                        "f:mountPath": {},
                        "f:name": {}
                      }
                    }
                  }
                },
                "f:nodeSelector": {},
                "f:priorityClassName": {},
                "f:restartPolicy": {},
                "f:schedulerName": {},
                "f:securityContext": {},
                "f:serviceAccount": {},
                "f:serviceAccountName": {},
                "f:terminationGracePeriodSeconds": {},
                "f:tolerations": {},
                "f:volumes": {
                  ".": {},
                  "k:{\"name\":\"cni-bin-dir\"}": {
                    ".": {},
                    "f:hostPath": {
                      ".": {},
                      "f:path": {},
                      "f:type": {}
                    },
                    "f:name": {}
                  },
                  "k:{\"name\":\"cni-log-dir\"}": {
                    ".": {},
                    "f:hostPath": {
                      ".": {},
                      "f:path": {},
                      "f:type": {}
                    },
                    "f:name": {}
                  },
                  "k:{\"name\":\"cni-net-dir\"}": {
                    ".": {},
                    "f:hostPath": {
                      ".": {},
                      "f:path": {},
                      "f:type": {}
                    },
                    "f:name": {}
                  },
                  "k:{\"name\":\"host-local-net-dir\"}": {
                    ".": {},
                    "f:hostPath": {
                      ".": {},
                      "f:path": {},
                      "f:type": {}
                    },
                    "f:name": {}
                  },
                  "k:{\"name\":\"lib-modules\"}": {
                    ".": {},
                    "f:hostPath": {
                      ".": {},
                      "f:path": {},
                      "f:type": {}
                    },
                    "f:name": {}
                  },
                  "k:{\"name\":\"policysync\"}": {
                    ".": {},
                    "f:hostPath": {
                      ".": {},
                      "f:path": {},
                      "f:type": {}
                    },
                    "f:name": {}
                  },
                  "k:{\"name\":\"sys-fs\"}": {
                    ".": {},
                    "f:hostPath": {
                      ".": {},
                      "f:path": {},
                      "f:type": {}
                    },
                    "f:name": {}
                  },
                  "k:{\"name\":\"var-lib-calico\"}": {
                    ".": {},
                    "f:hostPath": {
                      ".": {},
                      "f:path": {},
                      "f:type": {}
                    },
                    "f:name": {}
                  },
                  "k:{\"name\":\"var-run-calico\"}": {
                    ".": {},
                    "f:hostPath": {
                      ".": {},
                      "f:path": {},
                      "f:type": {}
                    },
                    "f:name": {}
                  },
                  "k:{\"name\":\"xtables-lock\"}": {
                    ".": {},
                    "f:hostPath": {
                      ".": {},
                      "f:path": {},
                      "f:type": {}
                    },
                    "f:name": {}
                  }
                }
              }
            }
          },
          {
            "manager": "kubelite",
            "operation": "Update",
            "apiVersion": "v1",
            "time": "2023-03-30T19:17:08Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:status": {
                "f:conditions": {
                  "k:{\"type\":\"ContainersReady\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  },
                  "k:{\"type\":\"Initialized\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  },
                  "k:{\"type\":\"Ready\"}": {
                    ".": {},
                    "f:lastProbeTime": {},
                    "f:lastTransitionTime": {},
                    "f:status": {},
                    "f:type": {}
                  }
                },
                "f:containerStatuses": {},
                "f:hostIP": {},
                "f:initContainerStatuses": {},
                "f:phase": {},
                "f:podIP": {},
                "f:podIPs": {
                  ".": {},
                  "k:{\"ip\":\"10.0.2.15\"}": {
                    ".": {},
                    "f:ip": {}
                  }
                },
                "f:startTime": {}
              }
            },
            "subresource": "status"
          }
        ]
      },
      "spec": {
        "volumes": [
          {
            "name": "lib-modules",
            "hostPath": {
              "path": "/lib/modules",
              "type": ""
            }
          },
          {
            "name": "var-run-calico",
            "hostPath": {
              "path": "/var/snap/microk8s/current/var/run/calico",
              "type": ""
            }
          },
          {
            "name": "var-lib-calico",
            "hostPath": {
              "path": "/var/snap/microk8s/current/var/lib/calico",
              "type": ""
            }
          },
          {
            "name": "xtables-lock",
            "hostPath": {
              "path": "/run/xtables.lock",
              "type": "FileOrCreate"
            }
          },
          {
            "name": "sys-fs",
            "hostPath": {
              "path": "/sys/fs/",
              "type": "DirectoryOrCreate"
            }
          },
          {
            "name": "cni-bin-dir",
            "hostPath": {
              "path": "/var/snap/microk8s/current/opt/cni/bin",
              "type": ""
            }
          },
          {
            "name": "cni-net-dir",
            "hostPath": {
              "path": "/var/snap/microk8s/current/args/cni-network",
              "type": ""
            }
          },
          {
            "name": "cni-log-dir",
            "hostPath": {
              "path": "/var/snap/microk8s/common/var/log/calico/cni",
              "type": ""
            }
          },
          {
            "name": "host-local-net-dir",
            "hostPath": {
              "path": "/var/snap/microk8s/current/var/lib/cni/networks",
              "type": ""
            }
          },
          {
            "name": "policysync",
            "hostPath": {
              "path": "/var/snap/microk8s/current/var/run/nodeagent",
              "type": "DirectoryOrCreate"
            }
          },
          {
            "name": "kube-api-access-bvd86",
            "projected": {
              "sources": [
                {
                  "serviceAccountToken": {
                    "expirationSeconds": 3607,
                    "path": "token"
                  }
                },
                {
                  "configMap": {
                    "name": "kube-root-ca.crt",
                    "items": [
                      {
                        "key": "ca.crt",
                        "path": "ca.crt"
                      }
                    ]
                  }
                },
                {
                  "downwardAPI": {
                    "items": [
                      {
                        "path": "namespace",
                        "fieldRef": {
                          "apiVersion": "v1",
                          "fieldPath": "metadata.namespace"
                        }
                      }
                    ]
                  }
                }
              ],
              "defaultMode": 420
            }
          }
        ],
        "initContainers": [
          {
            "name": "upgrade-ipam",
            "image": "docker.io/calico/cni:v3.23.5",
            "command": [
              "/opt/cni/bin/calico-ipam",
              "-upgrade"
            ],
            "envFrom": [
              {
                "configMapRef": {
                  "name": "kubernetes-services-endpoint",
                  "optional": true
                }
              }
            ],
            "env": [
              {
                "name": "KUBERNETES_NODE_NAME",
                "valueFrom": {
                  "fieldRef": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.nodeName"
                  }
                }
              },
              {
                "name": "CALICO_NETWORKING_BACKEND",
                "valueFrom": {
                  "configMapKeyRef": {
                    "name": "calico-config",
                    "key": "calico_backend"
                  }
                }
              }
            ],
            "resources": {},
            "volumeMounts": [
              {
                "name": "host-local-net-dir",
                "mountPath": "/var/lib/cni/networks"
              },
              {
                "name": "cni-bin-dir",
                "mountPath": "/host/opt/cni/bin"
              },
              {
                "name": "kube-api-access-bvd86",
                "readOnly": true,
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
              }
            ],
            "terminationMessagePath": "/dev/termination-log",
            "terminationMessagePolicy": "File",
            "imagePullPolicy": "IfNotPresent",
            "securityContext": {
              "privileged": true
            }
          },
          {
            "name": "install-cni",
            "image": "docker.io/calico/cni:v3.23.5",
            "command": [
              "/opt/cni/bin/install"
            ],
            "envFrom": [
              {
                "configMapRef": {
                  "name": "kubernetes-services-endpoint",
                  "optional": true
                }
              }
            ],
            "env": [
              {
                "name": "CNI_CONF_NAME",
                "value": "10-calico.conflist"
              },
              {
                "name": "CNI_NETWORK_CONFIG",
                "valueFrom": {
                  "configMapKeyRef": {
                    "name": "calico-config",
                    "key": "cni_network_config"
                  }
                }
              },
              {
                "name": "KUBERNETES_NODE_NAME",
                "valueFrom": {
                  "fieldRef": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.nodeName"
                  }
                }
              },
              {
                "name": "CNI_MTU",
                "valueFrom": {
                  "configMapKeyRef": {
                    "name": "calico-config",
                    "key": "veth_mtu"
                  }
                }
              },
              {
                "name": "SLEEP",
                "value": "false"
              },
              {
                "name": "CNI_NET_DIR",
                "value": "/var/snap/microk8s/current/args/cni-network"
              }
            ],
            "resources": {},
            "volumeMounts": [
              {
                "name": "cni-bin-dir",
                "mountPath": "/host/opt/cni/bin"
              },
              {
                "name": "cni-net-dir",
                "mountPath": "/host/etc/cni/net.d"
              },
              {
                "name": "kube-api-access-bvd86",
                "readOnly": true,
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
              }
            ],
            "terminationMessagePath": "/dev/termination-log",
            "terminationMessagePolicy": "File",
            "imagePullPolicy": "IfNotPresent",
            "securityContext": {
              "privileged": true
            }
          }
        ],
        "containers": [
          {
            "name": "calico-node",
            "image": "docker.io/calico/node:v3.23.5",
            "envFrom": [
              {
                "configMapRef": {
                  "name": "kubernetes-services-endpoint",
                  "optional": true
                }
              }
            ],
            "env": [
              {
                "name": "DATASTORE_TYPE",
                "value": "kubernetes"
              },
              {
                "name": "WAIT_FOR_DATASTORE",
                "value": "true"
              },
              {
                "name": "NODENAME",
                "valueFrom": {
                  "fieldRef": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.nodeName"
                  }
                }
              },
              {
                "name": "CALICO_NETWORKING_BACKEND",
                "valueFrom": {
                  "configMapKeyRef": {
                    "name": "calico-config",
                    "key": "calico_backend"
                  }
                }
              },
              {
                "name": "CLUSTER_TYPE",
                "value": "k8s,bgp"
              },
              {
                "name": "IP",
                "value": "autodetect"
              },
              {
                "name": "IP_AUTODETECTION_METHOD",
                "value": "first-found"
              },
              {
                "name": "CALICO_IPV4POOL_VXLAN",
                "value": "Always"
              },
              {
                "name": "CALICO_IPV6POOL_VXLAN",
                "value": "Never"
              },
              {
                "name": "FELIX_IPINIPMTU",
                "valueFrom": {
                  "configMapKeyRef": {
                    "name": "calico-config",
                    "key": "veth_mtu"
                  }
                }
              },
              {
                "name": "FELIX_VXLANMTU",
                "valueFrom": {
                  "configMapKeyRef": {
                    "name": "calico-config",
                    "key": "veth_mtu"
                  }
                }
              },
              {
                "name": "FELIX_WIREGUARDMTU",
                "valueFrom": {
                  "configMapKeyRef": {
                    "name": "calico-config",
                    "key": "veth_mtu"
                  }
                }
              },
              {
                "name": "CALICO_IPV4POOL_CIDR",
                "value": "10.1.0.0/16"
              },
              {
                "name": "CALICO_DISABLE_FILE_LOGGING",
                "value": "true"
              },
              {
                "name": "FELIX_DEFAULTENDPOINTTOHOSTACTION",
                "value": "ACCEPT"
              },
              {
                "name": "FELIX_IPV6SUPPORT",
                "value": "false"
              },
              {
                "name": "FELIX_HEALTHENABLED",
                "value": "true"
              }
            ],
            "resources": {
              "requests": {
                "cpu": "250m"
              }
            },
            "volumeMounts": [
              {
                "name": "cni-net-dir",
                "mountPath": "/host/etc/cni/net.d"
              },
              {
                "name": "lib-modules",
                "readOnly": true,
                "mountPath": "/lib/modules"
              },
              {
                "name": "xtables-lock",
                "mountPath": "/run/xtables.lock"
              },
              {
                "name": "var-run-calico",
                "mountPath": "/var/run/calico"
              },
              {
                "name": "var-lib-calico",
                "mountPath": "/var/lib/calico"
              },
              {
                "name": "policysync",
                "mountPath": "/var/run/nodeagent"
              },
              {
                "name": "cni-log-dir",
                "readOnly": true,
                "mountPath": "/var/log/calico/cni"
              },
              {
                "name": "kube-api-access-bvd86",
                "readOnly": true,
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
              }
            ],
            "livenessProbe": {
              "exec": {
                "command": [
                  "/bin/calico-node",
                  "-felix-live"
                ]
              },
              "initialDelaySeconds": 10,
              "timeoutSeconds": 10,
              "periodSeconds": 10,
              "successThreshold": 1,
              "failureThreshold": 6
            },
            "readinessProbe": {
              "exec": {
                "command": [
                  "/bin/calico-node",
                  "-felix-ready"
                ]
              },
              "timeoutSeconds": 10,
              "periodSeconds": 10,
              "successThreshold": 1,
              "failureThreshold": 3
            },
            "lifecycle": {
              "preStop": {
                "exec": {
                  "command": [
                    "/bin/calico-node",
                    "-shutdown"
                  ]
                }
              }
            },
            "terminationMessagePath": "/dev/termination-log",
            "terminationMessagePolicy": "File",
            "imagePullPolicy": "IfNotPresent",
            "securityContext": {
              "privileged": true
            }
          }
        ],
        "restartPolicy": "Always",
        "terminationGracePeriodSeconds": 0,
        "dnsPolicy": "ClusterFirst",
        "nodeSelector": {
          "kubernetes.io/os": "linux"
        },
        "serviceAccountName": "calico-node",
        "serviceAccount": "calico-node",
        "nodeName": "vagrant",
        "hostNetwork": true,
        "securityContext": {},
        "affinity": {
          "nodeAffinity": {
            "requiredDuringSchedulingIgnoredDuringExecution": {
              "nodeSelectorTerms": [
                {
                  "matchFields": [
                    {
                      "key": "metadata.name",
                      "operator": "In",
                      "values": [
                        "vagrant"
                      ]
                    }
                  ]
                }
              ]
            }
          }
        },
        "schedulerName": "default-scheduler",
        "tolerations": [
          {
            "operator": "Exists",
            "effect": "NoSchedule"
          },
          {
            "key": "CriticalAddonsOnly",
            "operator": "Exists"
          },
          {
            "operator": "Exists",
            "effect": "NoExecute"
          },
          {
            "key": "node.kubernetes.io/not-ready",
            "operator": "Exists",
            "effect": "NoExecute"
          },
          {
            "key": "node.kubernetes.io/unreachable",
            "operator": "Exists",
            "effect": "NoExecute"
          },
          {
            "key": "node.kubernetes.io/disk-pressure",
            "operator": "Exists",
            "effect": "NoSchedule"
          },
          {
            "key": "node.kubernetes.io/memory-pressure",
            "operator": "Exists",
            "effect": "NoSchedule"
          },
          {
            "key": "node.kubernetes.io/pid-pressure",
            "operator": "Exists",
            "effect": "NoSchedule"
          },
          {
            "key": "node.kubernetes.io/unschedulable",
            "operator": "Exists",
            "effect": "NoSchedule"
          },
          {
            "key": "node.kubernetes.io/network-unavailable",
            "operator": "Exists",
            "effect": "NoSchedule"
          }
        ],
        "priorityClassName": "system-node-critical",
        "priority": 2000001000,
        "enableServiceLinks": true,
        "preemptionPolicy": "PreemptLowerPriority"
      },
      "status": {
        "phase": "Running",
        "conditions": [
          {
            "type": "Initialized",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-29T11:04:23Z"
          },
          {
            "type": "Ready",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-30T19:17:00Z"
          },
          {
            "type": "ContainersReady",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-30T19:17:00Z"
          },
          {
            "type": "PodScheduled",
            "status": "True",
            "lastProbeTime": null,
            "lastTransitionTime": "2023-03-29T10:25:07Z"
          }
        ],
        "hostIP": "10.0.2.15",
        "podIP": "10.0.2.15",
        "podIPs": [
          {
            "ip": "10.0.2.15"
          }
        ],
        "startTime": "2023-03-29T10:25:07Z",
        "initContainerStatuses": [
          {
            "name": "upgrade-ipam",
            "state": {
              "terminated": {
                "exitCode": 0,
                "reason": "Completed",
                "startedAt": "2023-03-29T11:04:17Z",
                "finishedAt": "2023-03-29T11:04:18Z",
                "containerID": "containerd://c3b024377fe0eb8fc1825746d243ae46eb5c067da12c30b2aa7c196774339185"
              }
            },
            "lastState": {},
            "ready": true,
            "restartCount": 1,
            "image": "docker.io/calico/cni:v3.23.5",
            "imageID": "docker.io/calico/cni@sha256:7ca5c455cff6c0d661e33918d95a1133afb450411dbfb7e4369a9ecf5e0212dc",
            "containerID": "containerd://c3b024377fe0eb8fc1825746d243ae46eb5c067da12c30b2aa7c196774339185"
          },
          {
            "name": "install-cni",
            "state": {
              "terminated": {
                "exitCode": 0,
                "reason": "Completed",
                "startedAt": "2023-03-29T11:04:31Z",
                "finishedAt": "2023-03-29T11:04:45Z",
                "containerID": "containerd://3d44970aa5b68459f8804f7555fffc1ac1077fe217d6e45655b411f1d6f4dc7c"
              }
            },
            "lastState": {},
            "ready": true,
            "restartCount": 0,
            "image": "docker.io/calico/cni:v3.23.5",
            "imageID": "docker.io/calico/cni@sha256:7ca5c455cff6c0d661e33918d95a1133afb450411dbfb7e4369a9ecf5e0212dc",
            "containerID": "containerd://3d44970aa5b68459f8804f7555fffc1ac1077fe217d6e45655b411f1d6f4dc7c"
          }
        ],
        "containerStatuses": [
          {
            "name": "calico-node",
            "state": {
              "running": {
                "startedAt": "2023-03-29T11:04:54Z"
              }
            },
            "lastState": {
              "terminated": {
                "exitCode": 255,
                "reason": "Unknown",
                "startedAt": "2023-03-29T10:25:49Z",
                "finishedAt": "2023-03-29T11:02:54Z",
                "containerID": "containerd://dc6cc1dea4e51f63921555cf431174b6ef6e2b57cfd0c29eb2e17429ca559f22"
              }
            },
            "ready": true,
            "restartCount": 1,
            "image": "docker.io/calico/node:v3.23.5",
            "imageID": "docker.io/calico/node@sha256:b7f4f7a0ce463de5d294fdf2bb13f61035ec6e3e5ee05dd61dcc8e79bc29d934",
            "containerID": "containerd://cdbffaaca814088a85c7f029b07a22d47bb9a7575b0c2b267eeb57198b61538f",
            "started": true
          }
        ],
        "qosClass": "Burstable"
      }
    }
  ]
}vagrant@vagrant:~$
```

<details>















--
Вот полный скрипт отработки с момента входа в ВМ.
-
```
--скрипт установки microk8s и дашборда
sudo apt update
sudo apt install snapd
sudo snap install microk8s --classic
mkdir -p $HOME/.kube/
sudo usermod -a -G microk8s vagrant
sudo chown -f -R vagrant ~/.kube
newgrp microk8s
microk8s status
microk8s enable dashboard
microk8s kubectl config view --raw > $HOME/.kube/config
sudo microk8s refresh-certs --cert front-proxy-client.crt
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl;
sudo mv ./kubectl /usr/local/bin/kubectl;
TOKEN=$(microk8s kubectl -n kube-system get secret | awk '$1 ~ "default-token" {print $1}')
microk8s kubectl -n kube-system get secret $TOKEN -o jsonpath='{.data.token}' | base64 -d
microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443 --address='0.0.0.0'
```
Что я здесь упустил?

```
vagrant@vagrant:~$ microk8s config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUREekNDQWZlZ0F3SUJBZ0lVR0lSc2htWW4rUW8rRGZmZUo5NDJZTVdiWm9Zd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0Z6RVZNQk1HQTFVRUF3d01NVEF1TVRVeUxqRTRNeTR4TUI0WERUSXpNRE15T1RFd01qUXhPVm9YRFRNegpNRE15TmpFd01qUXhPVm93RnpFVk1CTUdBMVVFQXd3TU1UQXVNVFV5TGpFNE15NHhNSUlCSWpBTkJna3Foa2lHCjl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUExTGc4RkowQXpyYkRrU3hhK1pXbmxxdkJMeTRsLzVZSU04MzgKNGFONmhUUURNeFJuZFNaaThDaG5KZ0V5amdBVnhhMTcyQy9EM2R6ODJhYVllcU9WMjVDMUlwTDhqZHVSVlJSUgp1WUlnS0NhVlpVQkUxeXNrQzRDN01mRXRFNjcwYksvOEtiZVVYNUxRYXRQd3VTODNYOFZHVjNkcHFaVGZnK3JRCkxUVWNxb25KRDROYk5DQ3RxUWVXajduQXJBQmRTb0RXSTBLOWhRY3FYTWIwZXBaUWZtZDJTUTNRMlJlT2NUcWgKMXN3QnBQWm43Yks3Yk9PMWxYRWNzSTNnMTdTNzlsaC9vZkJMMXRUVDZ4dFBZS24rNGluOXo3QUh3V1FrNXhtRgpGdTJlY2hPS3puRWtjQ1BmL04yZVNDYnl0Tm1XdVRoZkRrRnRkVStPN1REbnBYU1JGUUlEQVFBQm8xTXdVVEFkCkJnTlZIUTRFRmdRVUwwd1djeHdQVEQvUVJESmw0NGp0S2pPaCsyNHdId1lEVlIwakJCZ3dGb0FVTDB3V2N4d1AKVEQvUVJESmw0NGp0S2pPaCsyNHdEd1lEVlIwVEFRSC9CQVV3QXdFQi96QU5CZ2txaGtpRzl3MEJBUXNGQUFPQwpBUUVBanFkWnRYQ2ZvYUpCU3JMMURjOGZDWWV0NCszUFlESFhOZnEyT0YwbjhuZkpjZ3licytoTXZPNnlGNjFlClJsSmkwbXd6T0wwS2dIMUdGT0ZqR0xBMkVyNkpiWU1oS2d1K3BXWUV1Y0x0aW8wVHgrdFNoR1B3WHYrQThYUUYKT0hmeGJ2bFowMFJXaDNZUHlCV0R2Y01SZVlmbHpEbjdIbTJucUduWU5HVVl3T1pZTEIzamNOTkxWRUFSaWNIUApuYU1pRXNLL3dOZDNCRVFzNStONGZFaTl2Z3RRd1ZxRmFVNFRPb0d1ei9WRGw2L2RTMkNCUVg2dHBiY0Q2L2JJCnh3N2lESWI5RGRIY2s1cnF6bnYySDVBTXdTeWl6dzZId3oveG5YdjJWSkxvcEJZdmlBS0RqdGx0eGNSdzVLOTUKOHIrVjdrZ3ZxUndYYWtFTmZFSm1xdXlibUE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://10.0.2.15:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
current-context: microk8s
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: RFVaczk2L0cxUFNqZkg1ai96ZmlSaDQxSGFna09GMThhN1BDUU9BVHRuND0K

vagrant@vagrant:~$ microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443 --address='0.0.0.0'
Forwarding from 0.0.0.0:10443 -> 8443
```
при попытке перейти на IP ВМ с клиента:
https://10.0.2.15:10443
Вот что получается...
![2023-03-29_145046](https://user-images.githubusercontent.com/106807250/228511562-743e2b3d-3e93-41fe-a958-fbd8f8e2779f.jpg)

редактирование файла /var/snap/microk8s/current/certs/csr.conf.template
тоже результатов не дает...
```
vagrant@vagrant:~$ cat /var/snap/microk8s/current/certs/csr.conf.template
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = GB
ST = Canonical
L = Canonical
O = Canonical
OU = Canonical
CN = 127.0.0.1

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster
DNS.5 = kubernetes.default.svc.cluster.local
IP.1 = 127.0.0.1
IP.2 = 10.152.183.1
IP.4 = 10.152.183.1
#MOREIPS

[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment,digitalSignature
extendedKeyUsage=serverAuth,clientAuth
subjectAltName=@alt_names
vagrant@vagrant:~$
```

Почему именно так отредактирвал?
В следствии рекомендации:
https://stackoverflow.com/questions/63451290/microk8s-devops-unable-to-connect-to-the-server-x509-certificate-is-valid-f
на место IP.4 пытался так же и адрес ВМ пробросить 10.0.2.15 Однако тоже без результатов.

<details>

__<summary>Предпринятые шаги</summary>__
Развернул я все на ВМ ubuntu 20.04 на своем же компьютере. 
Установку ввел как и по инструкции выше в этом файле, так и по другим(было подозрение что microk8s не правильно встал)
Благодря этим туториалам решилась проблема 
```
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```
https://gitlab.com/xavki/tutoriels-microk8s/-/blob/master/01-installation-manuelle/slides.md
https://gitlab.com/xavki/tutoriels-microk8s/-/blob/master/02-extension-dashboard/slides.md

Собственно сам config view
```
vagrant@vagrant:~$ microk8s config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ********TOKEN********
    server: https://10.0.2.15:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
current-context: microk8s
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: ********TOKEN********

vagrant@vagrant:~$
```

Сам microk8s стоит и дашборд включен.
```
vagrant@vagrant:~$ microk8s status
microk8s is running
high-availability: no
  datastore master nodes: 127.0.0.1:19001
  datastore standby nodes: none
addons:
  enabled:
    dashboard            # (core) The Kubernetes dashboard
    ha-cluster           # (core) Configure high availability on the current node
    helm                 # (core) Helm - the package manager for Kubernetes
    helm3                # (core) Helm 3 - the package manager for Kubernetes
    metrics-server       # (core) K8s Metrics Server for API access to service metrics
```
сертификаты обновил.
Так же проверял не упал ли сервис
```
vagrant@vagrant:~$ microk8s kubectl get pods -n kube-system
NAME                                        READY   STATUS    RESTARTS         AGE
dashboard-metrics-scraper-7bc864c59-mnm2r   1/1     Running   4 (4h6m ago)     17h
calico-node-xldpd                           1/1     Running   4 (4h6m ago)     17h
calico-kube-controllers-6ff578f9bd-ljqvs    1/1     Running   4 (4h6m ago)     17h
kubernetes-dashboard-dc96f9fc-hs7qc         1/1     Running   11 (4m21s ago)   17h
metrics-server-6f754f88d-dgtsk              1/1     Running   22 (3m55s ago)   17h
vagrant@vagrant:~$
```
Добавлял правило для фаервола
```
sudo ufw allow 8001/tcp
```
После чего пытался запустить Дашборд
```
microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443
```
под разными вариантами затем пытался подключится с клиента
```
https://localhost:10443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
здесь натыкаюсь на 
ERR_CONNECTION_REFUSED

Пытался другой вариант указав сам IP ВМ

https://10.0.2.15:10443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

здесь натыкаюсь на
( ERR_CONNECTION_TIMED_OUT )
```

Пытался решить проблему с прокси(может в нем дело) 
потому что ранее всплывала такая ошибка
```
Unable to connect to the server: net/http: TLS handshake timeout
```
Gосле выполнения этих команд, ошибка выше исчезла, но к дашборду так и не смог подключится.
```
unset http_proxy
unset https_proxy
```

Пытался так же пройти путь заново по этой документации

https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

Удается подключится только непосредственно с самого хоста, а вот удаленно с другого клиента никак.

Пробрасывал еще порты в VirtualBox на конкретной машинке, но все тщетно.

Пытался установить Ubuntu как вторую подсистему, однако там нет systemd и в следствии этого образовалось ряд проблем которых не было на ВМ изначально.
Просто уже нет времени разбиратся еще и с systemd на локале.

<details>

