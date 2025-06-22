### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №11 - Bash.**  
**Цель** - Написать скрипт на языке Bash.

**Задание:**\
Написать скрипт для CRON, который раз в час будет формировать письмо и отправлять на заданную почту.\
Необходимая информация в письме:
1) Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
2) Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
3) Ошибки веб-сервера/приложения c момента последнего запуска;
4) Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта.
5) Скрипт должен предотвращать одновременный запуск нескольких копий, до его завершения.


****
#### **Описание реализации:**  


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
##### Пример отработки:
Первый раз:
```
$ ./otus_bash.sh access-4560-644067.log 
script report
=====
Log from 2000-01-01T00:00:00 to 2025-05-02T14:45:52+00:00

5 most popular IPs
=====
     39 109.236.252.130
     36 212.57.117.19
     33 188.43.241.106
     17 217.118.66.161
     17 185.6.8.9

4 most popular requests
=====
    151 GET /
     61 POST /wp-login.php
     59 GET /wp-login.php
     57 POST /xmlrpc.php
     23 GET /robots.txt

Top server-errors-requests
=====
      1 POST /wp-content/uploads/2018/08/seo_script.php HTTP/1.1" 500
      1 GET /wp-includes/ID3/comay.php HTTP/1.1" 500
      1 GET /wp-content/plugins/uploadify/includes/check.php HTTP/1.1" 500

HTTP-codes
=====
    497 200
     95 301
     48 404
      7 400
      3 500
      2 499
      1 403
      1 304
```
Второй раз:
```
$ ./otus_bash.sh access-4560-644067.log 
script report
=====
Log from 2025-05-02T14:45:52+00:00 to 2025-05-02T14:45:56+00:00

5 most popular IPs
=====

4 most popular requests
=====

Top server-errors-requests
=====

HTTP-codes
=====
```

Добавляем в CRON:
```
0 */1 * * * /bin/bash -l -c '/home/vagrant/otus_bash.sh /path/to/access-4560-644067.log | mail -s "LOG REPORT" "email@example.com"'
```

