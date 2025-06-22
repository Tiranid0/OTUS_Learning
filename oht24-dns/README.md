### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №24 - Настраиваем split-dns**  
**Цель** - Создать домашнюю сетевую лабораторию; Изучить основы DNS; Научиться работать с технологией Split-DNS в Linux-based системах.

**Задание:**  
Что нужно сделать?

    взять стенд https://github.com/erlong15/vagrant-bind

    добавить еще один сервер client2

    завести в зоне dns.lab

    имена

    web1 - смотрит на клиент1

    web2 смотрит на клиент2

    завести еще одну зону newdns.lab

    завести в ней запись

    www - смотрит на обоих клиентов

    настроить split-dns

    клиент1 - видит обе зоны, но в зоне dns.lab только web1

    клиент2 видит только dns.lab


****
#### **Описание реализации:**  
Реализация выполнена согласно описанным в методическом указании шагам: https://docs.google.com/document/d/13kjusaFEzv6Ip_9soeDj2Ry-6WK8IDX7/edit?tab=t.0 \
Дз выполнено через ansible и проверено вручную \

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
Vagrantfile - alalinux/9

***
##### Запуск стенда. Запуск локального скрипта и playbook.
```
$ vagrant status

```
##### Проверка:
Client:
```
[vagrant@client ~]$ ping www.newdns.lab
PING www.newdns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from client (192.168.50.15): icmp_seq=1 ttl=64 time=0.022 ms
64 bytes from client (192.168.50.15): icmp_seq=2 ttl=64 time=0.112 ms
64 bytes from client (192.168.50.15): icmp_seq=3 ttl=64 time=0.133 ms
^C
--- www.newdns.lab ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 0.022/0.089/0.133/0.048 ms
[vagrant@client ~]$ ping web1.dns.lab
PING web1.dns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from client (192.168.50.15): icmp_seq=1 ttl=64 time=0.012 ms
64 bytes from client (192.168.50.15): icmp_seq=2 ttl=64 time=0.111 ms
64 bytes from client (192.168.50.15): icmp_seq=3 ttl=64 time=0.131 ms
^C
--- web1.dns.lab ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2031ms
rtt min/avg/max/mdev = 0.012/0.084/0.131/0.052 ms
[vagrant@client ~]$ ping web2.dns.lab
ping: web2.dns.lab: Name or service not known
[vagrant@client ~]$ 

```
Client2:
```
[vagrant@client2 ~]$ ping www.newdns.lab
ping: www.newdns.lab: Name or service not known
[vagrant@client2 ~]$ ping web1.dns.lab
PING web1.dns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=1 ttl=64 time=1.43 ms
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=2 ttl=64 time=1.75 ms
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=3 ttl=64 time=0.996 ms
^C
--- web1.dns.lab ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 0.996/1.390/1.745/0.307 ms
[vagrant@client2 ~]$ ping web2.dns.lab
PING web2.dns.lab (192.168.50.16) 56(84) bytes of data.
64 bytes from client2 (192.168.50.16): icmp_seq=1 ttl=64 time=0.163 ms
64 bytes from client2 (192.168.50.16): icmp_seq=2 ttl=64 time=0.158 ms
64 bytes from client2 (192.168.50.16): icmp_seq=3 ttl=64 time=0.200 ms
^C
--- web2.dns.lab ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 0.158/0.173/0.200/0.018 ms
[vagrant@client2 ~]$ 

```
