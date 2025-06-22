### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №8 - Сборка RPM-пакета и создание репозитория**  
**Цель** - Научиться собирать RPM-пакеты. Создавать собственный RPM-репозиторий. 

**Задание:**
1) Cоздать свой RPM (можно взять свое приложение, либо собрать к примеру Apache с определенными опциями);
2) Cоздать свой репозиторий и разместить там ранее собранный RPM;
3) Реализовать это все либо в Vagrant, либо развернуть у себя через Nginx и дать ссылку на репозиторий.

****
#### **Описание реализации:**  
Реализация выполнена согласно описанным в методическом указании шагам: [[[https://docs.google.com/document/d/1jTq4l4UD1CF9C_VFqGXZYunXA2RUap70CfKm_6OXZBU/edit?tab=t.0](https://docs.google.com/document/d/1xursgUsGDVTLh4B_r0XGw_flPzd5lSJ0nfMFL-HQmFs/edit?tab=t.0)](https://docs.google.com/document/d/1L0VtVCn2tXmC0Pirlfhnr6rEpOANbP-C/edit?tab=t.0)](https://docs.google.com/document/d/1yeYpcY39RxBGVIjBwTE12Y_VdjvsqCV3OFie2tvAtsg/edit?tab=t.0) \
Дз выполнено через ansible и вагрант. \


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
Vagrantfile - almalinux/9\
Предварительно создаем файл *hosts*. \

***
##### Запуск плейбука.
Дз выполнено через ансибл. Результат его работы в файле ansible-res.txt
```
$ ansible-playbook -i hosts rpm.yml
