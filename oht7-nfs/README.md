### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №7 - Работа с NFS**  
**Цель** - Научиться самостоятельно разворачивать сервис NFS и подключать к нему клиентов.

**Критерии:**  
Статус "Принято" ставится при выполнении основных требований.
1) vagrant up должен поднимать 2 виртуалки: сервер и клиент;
2) на сервере должна быть настроена директория для отдачи по NFS;
3) на клиенте она должна автоматически монтироваться при старте (fstab или autofs);
4) в сетевой директории должна быть папка upload с правами на запись;
5) требования для NFS: NFS версии 3.

****
#### **Описание реализации:**  
Реализация выполнена согласно описанным в методическом указании шагам: [https://docs.google.com/document/d/1jTq4l4UD1CF9C_VFqGXZYunXA2RUap70CfKm_6OXZBU/edit?tab=t.0](https://docs.google.com/document/d/1Xz7dCWSzaM8Q0VzBt78K3emh7zlNX3C-Q27B6UuVexI/edit?tab=t.0#heading=h.csr8pmcyj3iq) \
Дз выполнено через ansible. \
Плэйбук создает тестовые файлы, перезагружает хосты и выводит содержимое каталогов согласно этапам проверки в методичке.

***
##### Подготовка стенда.
```
$ ansible --version
ansible [core 2.16.3]
  config file = None
  configured module search path = ['/home/yup/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/yup/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.12.3 (main, Feb  4 2025, 14:48:35) [GCC 13.3.0] (/usr/bin/python3)
  jinja version = 3.1.2
  libyaml = True

$ vagrant -v
Vagrant 2.4.3
```
Vagrantfile - generic/ubuntu2204\
Предварительно создаем файл *hosts*. \

***
##### Запуск стенда. Запуск локального скрипта и playbook.
Запускаем стенд:
```
$ vagrant up
$ vagrant status
Current machine states:

nfss                      running (virtualbox)
nfsc                      running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```
Запускаем ansible-playbook:
```
$ ansible-playbook -i hosts nfs.yml
```
Результат выполенения плейбука в файле ansible-result.txt
