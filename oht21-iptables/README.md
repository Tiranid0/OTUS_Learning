### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №21 - Сценарии iptables**  
**Цель** - Написать сценарии iptables.

**Задание:**  
1) Реализовать knocking port: centralRouter может попасть на ssh inetrRouter через knock скрипт
2) Добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост.
3) Запустить nginx на centralServer.
4) Пробросить 80й порт на inetRouter2 8080.
5) Дефолт в инет оставить через inetRouter.


****
#### **Описание реализации:**  

Дз выполнено через ansible и проверено вручную \
Реализация выполнена на основе стенда oht19-network, но без office-сегментов. \
К centralRouter (192.168.255.13) добавлено подключение inetRouter2 (192.168.255.14, 10.10.10.2, 192.168.56.13).


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
```
$ vagrant status
Current machine states:

inetRouter                running (virtualbox)
inetRouter2               running (virtualbox)
centralRouter             running (virtualbox)
centralServer             running (virtualbox)
office1Router             running (virtualbox)
office1Server             running (virtualbox)
office2Router             running (virtualbox)
office2Server             running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```
Запускаем плэйбук:
```
$ ansible-playbook -i hosts iptables.yml 
```
***
##### Проверка.
Проверяем с хостовой машины доступ до centralServer через 80й порт (сам nginx настроен на 8080):
```
$ curl http://192.168.56.13:80
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

Проверяем knockd:
```
root@centralRouter:~# ssh vagrant@192.168.255.1
ssh: connect to host 192.168.255.1 port 22: Connection timed out

root@centralRouter:~# knock 192.168.255.1 7000 8000 9000
root@centralRouter:~# ssh vagrant@192.168.255.1
vagrant@192.168.255.1's password:

root@centralRouter:~# knock 192.168.255.1 9000 8000 7000
root@centralRouter:~# ssh vagrant@192.168.255.1
ssh: connect to host 192.168.255.1 port 22: Connection timed out
```

