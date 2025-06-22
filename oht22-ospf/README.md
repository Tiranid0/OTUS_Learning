### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №22 - OSPF**  
**Цель** - Создать домашнюю сетевую лабораторию; Научится настраивать протокол OSPF в Linux-based системах..

**Задание:**  
1) Поднять три виртуалки
2) Объединить их разными vlan
поднять OSPF между машинами на базе Quagga;\
изобразить ассиметричный роутинг;\
сделать один из линков "дорогим", но что бы при этом роутинг был симметричным.



****
#### **Описание реализации:**  
Реализация выполнена согласно описанным в методическом указании шагам: https://docs.google.com/document/d/1c3p-2PQl-73G8uKJaqmyCaw_CtRQipAt/edit?tab=t.0 \
Дз выполнено через ansible-provision и проверено вручную \
Ниже представлена схема сети:\
![Схема сети](https://github.com/YuP26/O_HT/blob/main/oht22-ospf/network.png)\

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
##### Запуск cтенда.
Настройка виртуальных машин происходит на этапе провижининга.
```
$ vagrant up
---
$ vagrant status
Current machine states:

router1                   running (virtualbox)
router2                   running (virtualbox)
router3                   running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

***
##### Проверка.
Проверяем таблицы маршрутизации:
```
root@router1:~# vtysh

Hello, this is FRRouting (version 10.3).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

router1# show ip route ospf 
Codes: K - kernel route, C - connected, L - local, S - static,
       R - RIP, O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric, t - Table-Direct,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

IPv4 unicast VRF default:
O   10.0.10.0/30 [110/300] via 10.0.12.2, eth2, weight 1, 00:02:07
O>* 10.0.11.0/30 [110/200] via 10.0.12.2, eth2, weight 1, 00:02:07
O   10.0.12.0/30 [110/100] is directly connected, eth2, weight 1, 00:02:42
O   192.168.10.0/24 [110/100] is directly connected, eth3, weight 1, 00:02:42
O>* 192.168.20.0/24 [110/300] via 10.0.12.2, eth2, weight 1, 00:02:07
O>* 192.168.30.0/24 [110/200] via 10.0.12.2, eth2, weight 1, 00:02:07
router1# 

root@router2:~# vtysh

Hello, this is FRRouting (version 10.3).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

router2# show ip route ospf 
Codes: K - kernel route, C - connected, L - local, S - static,
       R - RIP, O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric, t - Table-Direct,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

IPv4 unicast VRF default:
O   10.0.10.0/30 [110/100] is directly connected, eth1, weight 1, 00:02:41
O   10.0.11.0/30 [110/100] is directly connected, eth2, weight 1, 00:02:41
O>* 10.0.12.0/30 [110/200] via 10.0.10.1, eth1, weight 1, 00:02:06
  *                        via 10.0.11.1, eth2, weight 1, 00:02:06
O>* 192.168.10.0/24 [110/200] via 10.0.10.1, eth1, weight 1, 00:02:06
O   192.168.20.0/24 [110/100] is directly connected, eth3, weight 1, 00:02:41
O>* 192.168.30.0/24 [110/200] via 10.0.11.1, eth2, weight 1, 00:02:06
router2# 

root@router3:~# vtysh

Hello, this is FRRouting (version 10.3).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

router3# show ip route ospf 
Codes: K - kernel route, C - connected, L - local, S - static,
       R - RIP, O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric, t - Table-Direct,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

IPv4 unicast VRF default:
O>* 10.0.10.0/30 [110/200] via 10.0.11.2, eth1, weight 1, 00:02:06
O   10.0.11.0/30 [110/100] is directly connected, eth1, weight 1, 00:02:41
O   10.0.12.0/30 [110/100] is directly connected, eth2, weight 1, 00:02:41
O>* 192.168.10.0/24 [110/200] via 10.0.12.1, eth2, weight 1, 00:02:06
O>* 192.168.20.0/24 [110/200] via 10.0.11.2, eth1, weight 1, 00:02:06
O   192.168.30.0/24 [110/100] is directly connected, eth3, weight 1, 00:02:41
router3# 
```

Проверяем ассиметричный роутинг (для этого предварительно увеличили стоимость интерфейса enp0s8 на router1). Запросы принимаются на одном интерфейсе, а ответы уходят с другого:
```
root@router1:~# ping -I 192.168.10.1 192.168.20.1

root@router2:~# tcpdump -i eth2
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth2, link-type EN10MB (Ethernet), snapshot length 262144 bytes
19:48:00.225407 IP 192.168.10.1 > router2: ICMP echo request, id 2, seq 10, length 64
19:48:00.420819 IP 10.0.11.1 > ospf-all.mcast.net: OSPFv2, Hello, length 48
19:48:00.421340 IP router2 > ospf-all.mcast.net: OSPFv2, Hello, length 48
19:48:01.228192 IP 192.168.10.1 > router2: ICMP echo request, id 2, seq 11, length 64
19:48:02.229516 IP 192.168.10.1 > router2: ICMP echo request, id 2, seq 12, length 64
19:48:03.231626 IP 192.168.10.1 > router2: ICMP echo request, id 2, seq 13, length 64
19:48:04.233030 IP 192.168.10.1 > router2: ICMP echo request, id 2, seq 14, length 64
19:48:05.235678 IP 192.168.10.1 > router2: ICMP echo request, id 2, seq 15, length 64
19:48:06.236621 IP 192.168.10.1 > router2: ICMP echo request, id 2, seq 16, length 64

root@router2:~# tcpdump -i eth1
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
19:48:11.245262 IP router2 > 192.168.10.1: ICMP echo reply, id 2, seq 21, length 64
19:48:12.247842 IP router2 > 192.168.10.1: ICMP echo reply, id 2, seq 22, length 64
19:48:13.248495 IP router2 > 192.168.10.1: ICMP echo reply, id 2, seq 23, length 64
19:48:14.249711 IP router2 > 192.168.10.1: ICMP echo reply, id 2, seq 24, length 64
19:48:15.251954 IP router2 > 192.168.10.1: ICMP echo reply, id 2, seq 25, length 64
19:48:16.253279 IP router2 > 192.168.10.1: ICMP echo reply, id 2, seq 26, length 64
19:48:17.255809 IP router2 > 192.168.10.1: ICMP echo reply, id 2, seq 27, length 64
19:48:18.255868 IP router2 > 192.168.10.1: ICMP echo reply, id 2, seq 28, length 64
19:48:19.257460 IP router2 > 192.168.10.1: ICMP echo reply, id 2, seq 29, length 64
```

Проверяем симметричный роутинг (для этого поменяем стоимость интерфейса enp0s8 на router2 и меняем значение на true для symmetric_routing в defaults/main.yml). Запросы и ответы на одном интерфейсе:
```
ansible-playbook -i ansible/hosts -l all ansible/provision.yml -t setup_ospf -e "host_key_checking=false" 

root@router1:~# ping -I 192.168.10.1 192.168.20.1

root@router2:~# tcpdump -i eth2
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth2, link-type EN10MB (Ethernet), snapshot length 262144 bytes
20:21:18.648549 IP router2 > 192.168.10.1: ICMP echo reply, id 9, seq 32, length 64
20:21:18.967732 IP router2 > ospf-all.mcast.net: OSPFv2, Hello, length 48
20:21:18.969644 IP 10.0.11.1 > ospf-all.mcast.net: OSPFv2, Hello, length 48
20:21:18.971334 IP router2 > 10.0.11.1: OSPFv2, LS-Update, length 88
20:21:18.972851 IP router2 > ospf-all.mcast.net: OSPFv2, LS-Update, length 88
20:21:19.654413 IP 192.168.10.1 > router2: ICMP echo request, id 9, seq 33, length 64
20:21:19.654498 IP router2 > 192.168.10.1: ICMP echo reply, id 9, seq 33, length 64
20:21:19.975657 IP 10.0.11.1 > ospf-all.mcast.net: OSPFv2, LS-Ack, length 44
20:21:20.658457 IP 192.168.10.1 > router2: ICMP echo request, id 9, seq 34, length 64
20:21:20.658536 IP router2 > 192.168.10.1: ICMP echo reply, id 9, seq 34, length 64
20:21:21.661125 IP 192.168.10.1 > router2: ICMP echo request, id 9, seq 35, length 64
20:21:21.661188 IP router2 > 192.168.10.1: ICMP echo reply, id 9, seq 35, length 64
20:21:22.662805 IP 192.168.10.1 > router2: ICMP echo request, id 9, seq 36, length 64
20:21:22.662907 IP router2 > 192.168.10.1: ICMP echo reply, id 9, seq 36, length 64
```
