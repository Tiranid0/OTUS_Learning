### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №25 - Строим бонды и вланы**  
**Цель** - Научиться настраивать VLAN и LACP.

**Задание:**  
в Office1 в тестовой подсети появляется сервера с доп интерфейсами и адресами в internal сети testLAN:\

    testClient1 - 10.10.10.254\
    testClient2 - 10.10.10.254\
    testServer1- 10.10.10.1\
    testServer2- 10.10.10.1\

Равести вланами:\
testClient1 <-> testServer1\
testClient2 <-> testServer2\

Между centralRouter и inetRouter "пробросить" 2 линка (общая inernal сеть) и объединить их в бонд, проверить работу c отключением интерфейсов.

****
#### **Описание реализации:**  
Реализация выполнена согласно описанным в методическом указании шагам: https://docs.google.com/document/d/1BO5cUT0u4ABzEOjogeHyCaNiYh76Bh73/edit?tab=t.0 \
Дз выполнено через vagrant+ansible и проверено вручную \

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
Vagrantfile - alalinux/9 + generic/ubuntu2204

***
##### Запуск стенда. Запуск локального скрипта и playbook.
```
$ vagrant status
Current machine states:

inetRouter                running (virtualbox)
centralRouter             running (virtualbox)
office1Router             running (virtualbox)
testClient1               running (virtualbox)
testServer1               running (virtualbox)
testClient2               running (virtualbox)
testServer2               running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```
**Топология**
![Топология](https://github.com/YuP26/O_HT/blob/main/oht25-vlan/top.png)\
***
##### Проверка:
**VLAN**
testClient1 <-> testServer1
```
[vagrant@testClient1 ~]$ ip a
5: eth1.1@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:94:e8:ee brd ff:ff:ff:ff:ff:ff
    inet 10.10.10.254/24 brd 10.10.10.255 scope global noprefixroute eth1.1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe94:e8ee/64 scope link 
       valid_lft forever preferred_lft forever
[vagrant@testClient1 ~]$ ping 10.10.10.1
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=1.57 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=1.38 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=2.40 ms
64 bytes from 10.10.10.1: icmp_seq=4 ttl=64 time=2.10 ms
^C
--- 10.10.10.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3012ms
rtt min/avg/max/mdev = 1.380/1.862/2.399/0.405 ms


[vagrant@testServer1 ~]$ ip a
5: eth1.1@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:1f:1a:34 brd ff:ff:ff:ff:ff:ff
    inet 10.10.10.1/24 brd 10.10.10.255 scope global noprefixroute eth1.1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe1f:1a34/64 scope link 
       valid_lft forever preferred_lft forever
[vagrant@testServer1 ~]$ sudo tcpdump -i enp0s8 -n -e
12:04:16.692261 08:00:27:1f:1a:34 > 08:00:27:94:e8:ee, ethertype 802.1Q (0x8100), length 46: vlan 1, p 0, ethertype ARP (0x0806), Reply 10.10.10.1 is-at 08:00:27:1f:1a:34, length 28
12:04:16.692882 08:00:27:94:e8:ee > 08:00:27:1f:1a:34, ethertype 802.1Q (0x8100), length 102: vlan 1, p 0, ethertype IPv4 (0x0800), 10.10.10.254 > 10.10.10.1: ICMP echo request, id 1, seq 1, length 64
12:04:16.692914 08:00:27:1f:1a:34 > 08:00:27:94:e8:ee, ethertype 802.1Q (0x8100), length 102: vlan 1, p 0, ethertype IPv4 (0x0800), 10.10.10.1 > 10.10.10.254: ICMP echo reply, id 1, seq 1, length 64
12:04:17.694030 08:00:27:94:e8:ee > 08:00:27:1f:1a:34, ethertype 802.1Q (0x8100), length 102: vlan 1, p 0, ethertype IPv4 (0x0800), 10.10.10.254 > 10.10.10.1: ICMP echo request, id 1, seq 2, length 64
12:04:17.694125 08:00:27:1f:1a:34 > 08:00:27:94:e8:ee, ethertype 802.1Q (0x8100), length 102: vlan 1, p 0, ethertype IPv4 (0x0800), 10.10.10.1 > 10.10.10.254: ICMP echo reply, id 1, seq 2, length 64
12:04:18.697398 08:00:27:94:e8:ee > 08:00:27:1f:1a:34, ethertype 802.1Q (0x8100), length 102: vlan 1, p 0, ethertype IPv4 (0x0800), 10.10.10.254 > 10.10.10.1: ICMP echo request, id 1, seq 3, length 64
12:04:18.697515 08:00:27:1f:1a:34 > 08:00:27:94:e8:ee, ethertype 802.1Q (0x8100), length 102: vlan 1, p 0, ethertype IPv4 (0x0800), 10.10.10.1 > 10.10.10.254: ICMP echo reply, id 1, seq 3, length 64
12:04:19.704422 08:00:27:94:e8:ee > 08:00:27:1f:1a:34, ethertype 802.1Q (0x8100), length 102: vlan 1, p 0, ethertype IPv4 (0x0800), 10.10.10.254 > 10.10.10.1: ICMP echo request, id 1, seq 4, length 64
12:04:19.704554 08:00:27:1f:1a:34 > 08:00:27:94:e8:ee, ethertype 802.1Q (0x8100), length 102: vlan 1, p 0, ethertype IPv4 (0x0800), 10.10.10.1 > 10.10.10.254: ICMP echo reply, id 1, seq 4, length 64
^C
```
testClient2 <-> testServer2
```
vagrant@testClient2:~$ ip a
5: vlan2@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:aa:79:20 brd ff:ff:ff:ff:ff:ff
    inet 10.10.10.254/24 brd 10.10.10.255 scope global vlan2
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feaa:7920/64 scope link 
       valid_lft forever preferred_lft forever
vagrant@testClient2:~$ ping 10.10.10.1
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=3.77 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=1.47 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=1.37 ms
64 bytes from 10.10.10.1: icmp_seq=4 ttl=64 time=1.25 ms
^C
--- 10.10.10.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3018ms
rtt min/avg/max/mdev = 1.249/1.965/3.768/1.043 ms


vagrant@testServer2:~$ ip a
5: vlan2@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:b4:f9:e7 brd ff:ff:ff:ff:ff:ff
    inet 10.10.10.1/24 brd 10.10.10.255 scope global vlan2
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feb4:f9e7/64 scope link 
       valid_lft forever preferred_lft forever
vagrant@testServer2:~$ sudo tcpdump -i enp0s8 -n -e
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on enp0s8, link-type EN10MB (Ethernet), snapshot length 262144 bytes
12:07:02.723153 08:00:27:aa:79:20 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 64: vlan 2, p 0, ethertype ARP (0x0806), Request who-has 10.10.10.1 tell 10.10.10.254, length 46
12:07:02.723196 08:00:27:b4:f9:e7 > 08:00:27:aa:79:20, ethertype 802.1Q (0x8100), length 46: vlan 2, p 0, ethertype ARP (0x0806), Reply 10.10.10.1 is-at 08:00:27:b4:f9:e7, length 28
12:07:02.726552 08:00:27:aa:79:20 > 08:00:27:b4:f9:e7, ethertype 802.1Q (0x8100), length 102: vlan 2, p 0, ethertype IPv4 (0x0800), 10.10.10.254 > 10.10.10.1: ICMP echo request, id 1, seq 1, length 64
12:07:02.726576 08:00:27:b4:f9:e7 > 08:00:27:aa:79:20, ethertype 802.1Q (0x8100), length 102: vlan 2, p 0, ethertype IPv4 (0x0800), 10.10.10.1 > 10.10.10.254: ICMP echo reply, id 1, seq 1, length 64
12:07:03.725696 08:00:27:aa:79:20 > 08:00:27:b4:f9:e7, ethertype 802.1Q (0x8100), length 102: vlan 2, p 0, ethertype IPv4 (0x0800), 10.10.10.254 > 10.10.10.1: ICMP echo request, id 1, seq 2, length 64
12:07:03.725768 08:00:27:b4:f9:e7 > 08:00:27:aa:79:20, ethertype 802.1Q (0x8100), length 102: vlan 2, p 0, ethertype IPv4 (0x0800), 10.10.10.1 > 10.10.10.254: ICMP echo reply, id 1, seq 2, length 64
12:07:04.741186 08:00:27:aa:79:20 > 08:00:27:b4:f9:e7, ethertype 802.1Q (0x8100), length 102: vlan 2, p 0, ethertype IPv4 (0x0800), 10.10.10.254 > 10.10.10.1: ICMP echo request, id 1, seq 3, length 64
12:07:04.741261 08:00:27:b4:f9:e7 > 08:00:27:aa:79:20, ethertype 802.1Q (0x8100), length 102: vlan 2, p 0, ethertype IPv4 (0x0800), 10.10.10.1 > 10.10.10.254: ICMP echo reply, id 1, seq 3, length 64
12:07:05.743323 08:00:27:aa:79:20 > 08:00:27:b4:f9:e7, ethertype 802.1Q (0x8100), length 102: vlan 2, p 0, ethertype IPv4 (0x0800), 10.10.10.254 > 10.10.10.1: ICMP echo request, id 1, seq 4, length 64
```
\
**Bonding**
```
[vagrant@inetRouter ~]$ ip a
3: eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bond0 state UP group default qlen 1000
    link/ether 08:00:27:cd:74:53 brd ff:ff:ff:ff:ff:ff
    altname enp0s8
4: eth2: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bond0 state UP group default qlen 1000
    link/ether 08:00:27:58:a0:b7 brd ff:ff:ff:ff:ff:ff
    altname enp0s9
6: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:cd:74:53 brd ff:ff:ff:ff:ff:ff
    inet 192.168.255.1/30 brd 192.168.255.3 scope global noprefixroute bond0
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fecd:7453/64 scope link 
       valid_lft forever preferred_lft forever
[vagrant@inetRouter ~]$ ping 192.168.255.2
PING 192.168.255.2 (192.168.255.2) 56(84) bytes of data.
64 bytes from 192.168.255.2: icmp_seq=1 ttl=64 time=1.54 ms
64 bytes from 192.168.255.2: icmp_seq=2 ttl=64 time=1.97 ms
64 bytes from 192.168.255.2: icmp_seq=3 ttl=64 time=1.15 ms
64 bytes from 192.168.255.2: icmp_seq=4 ttl=64 time=0.901 ms
64 bytes from 192.168.255.2: icmp_seq=5 ttl=64 time=1.18 ms
64 bytes from 192.168.255.2: icmp_seq=6 ttl=64 time=1.33 ms
64 bytes from 192.168.255.2: icmp_seq=7 ttl=64 time=1.71 ms
64 bytes from 192.168.255.2: icmp_seq=8 ttl=64 time=1.60 ms
64 bytes from 192.168.255.2: icmp_seq=9 ttl=64 time=1.64 ms

[vagrant@centralRouter ~]$ ip a
3: eth1: <BROADCAST,MULTICAST,SLAVE> mtu 1500 qdisc fq_codel master bond0 state DOWN group default qlen 1000
    link/ether 08:00:27:08:de:a5 brd ff:ff:ff:ff:ff:ff
    altname enp0s8
4: eth2: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bond0 state UP group default qlen 1000
    link/ether 08:00:27:78:b2:26 brd ff:ff:ff:ff:ff:ff
    altname enp0s9
7: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:78:b2:26 brd ff:ff:ff:ff:ff:ff
    inet 192.168.255.2/30 brd 192.168.255.3 scope global noprefixroute bond0
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe08:dea5/64 scope link 
       valid_lft forever preferred_lft forever
[vagrant@centralRouter ~]$ ping 192.168.255.1
PING 192.168.255.1 (192.168.255.1) 56(84) bytes of data.
64 bytes from 192.168.255.1: icmp_seq=1 ttl=64 time=1.04 ms
64 bytes from 192.168.255.1: icmp_seq=2 ttl=64 time=1.49 ms
64 bytes from 192.168.255.1: icmp_seq=3 ttl=64 time=1.53 ms
64 bytes from 192.168.255.1: icmp_seq=4 ttl=64 time=2.07 ms
64 bytes from 192.168.255.1: icmp_seq=5 ttl=64 time=1.95 ms
64 bytes from 192.168.255.1: icmp_seq=6 ttl=64 time=1.41 ms
64 bytes from 192.168.255.1: icmp_seq=7 ttl=64 time=1.14 ms
64 bytes from 192.168.255.1: icmp_seq=8 ttl=64 time=1.85 ms
^C
--- 192.168.255.1 ping statistics ---
8 packets transmitted, 8 received, 0% packet loss, time 7012ms
rtt min/avg/max/mdev = 1.043/1.561/2.070/0.348 ms

```
