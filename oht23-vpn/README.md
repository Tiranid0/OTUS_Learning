### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №23 - VPN**  
**Цель** - Создать домашнюю сетевую лабораторию. Научится настраивать VPN-сервер в Linux-based системах.

**Задание:**  
1) Настроить VPN между двумя ВМ в tun/tap режимах, замерить скорость в туннелях, сделать вывод об отличающихся показателях
2) Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на ВМ

****
#### **Описание реализации:**  

Дз выполнено через ansible и проверено вручную \
Сделано согласно шагам из методички - https://docs.google.com/document/d/1tJjZQzVccj0UoRlVLa-E-uxQtQDOCuW_sAk2nluiFo4/edit?tab=t.0 . \
\
В плэйбук заложено 2 паузы, когда потребуется проверить скорости на устройствах при помощи iperf3.\
\
Проверяемя в режиме tap:
```
6: tap0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
    link/ether a2:f4:6e:74:2c:2a brd ff:ff:ff:ff:ff:ff
    inet 10.10.10.1/24 scope global tap0
       valid_lft forever preferred_lft forever
4: tap0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
    link/ether b2:35:97:bd:47:51 brd ff:ff:ff:ff:ff:ff
    inet 10.10.10.2/24 scope global tap0
       valid_lft forever preferred_lft forever

TASK [Wait for handle tap-test] ***********************************************************************************************
[Wait for handle tap-test]
Press Enter to continue (if test is ready):

root@ovpn-server:~# iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 10.10.10.2, port 46372
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 46380
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  33.9 MBytes   285 Mbits/sec                  
[  5]   1.00-2.00   sec  46.3 MBytes   389 Mbits/sec                  
[  5]   2.00-3.00   sec  27.0 MBytes   227 Mbits/sec                  
[  5]   3.00-4.00   sec  25.7 MBytes   215 Mbits/sec                  
[  5]   4.00-5.00   sec  25.6 MBytes   215 Mbits/sec                  
[  5]   5.00-6.00   sec  36.1 MBytes   303 Mbits/sec                  
[  5]   6.00-7.00   sec  37.6 MBytes   316 Mbits/sec                  
[  5]   7.00-8.00   sec  29.9 MBytes   251 Mbits/sec                  
[  5]   8.00-9.00   sec  38.2 MBytes   320 Mbits/sec                  
[  5]   9.00-10.00  sec  42.0 MBytes   352 Mbits/sec                  
[  5]  10.00-11.00  sec  34.6 MBytes   291 Mbits/sec                  
[  5]  11.00-12.00  sec  29.6 MBytes   248 Mbits/sec                  
[  5]  12.00-13.00  sec  24.5 MBytes   206 Mbits/sec                  
[  5]  13.00-14.00  sec  39.6 MBytes   332 Mbits/sec                  
[  5]  14.00-15.00  sec  30.4 MBytes   255 Mbits/sec                  
[  5]  15.00-15.06  sec  1.38 MBytes   191 Mbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-15.06  sec   502 MBytes   280 Mbits/sec                  receiver


root@ovpn-client:~# iperf3 -c 10.10.10.1 -t 40
Connecting to host 10.10.10.1, port 5201
[  5] local 10.10.10.2 port 46380 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  39.2 MBytes   328 Mbits/sec   54    877 KBytes       
[  5]   1.00-2.00   sec  45.0 MBytes   377 Mbits/sec    0    979 KBytes       
[  5]   2.00-3.00   sec  27.5 MBytes   231 Mbits/sec  538    219 KBytes       
[  5]   3.00-4.00   sec  26.2 MBytes   220 Mbits/sec   58    190 KBytes       
[  5]   4.00-5.00   sec  25.0 MBytes   210 Mbits/sec    0    266 KBytes       
[  5]   5.00-6.00   sec  36.2 MBytes   304 Mbits/sec    0    350 KBytes       
[  5]   6.00-7.00   sec  38.8 MBytes   325 Mbits/sec    0    419 KBytes       
[  5]   7.00-8.00   sec  28.8 MBytes   241 Mbits/sec    4    347 KBytes       
[  5]   8.00-9.00   sec  38.8 MBytes   325 Mbits/sec    0    417 KBytes       
[  5]   9.00-10.00  sec  42.5 MBytes   357 Mbits/sec    0    484 KBytes       
[  5]  10.00-11.00  sec  33.8 MBytes   283 Mbits/sec   12    381 KBytes       
[  5]  11.00-12.00  sec  28.8 MBytes   241 Mbits/sec    6    328 KBytes       
[  5]  12.00-13.00  sec  25.0 MBytes   210 Mbits/sec    0    377 KBytes       
[  5]  13.00-14.00  sec  40.0 MBytes   336 Mbits/sec    0    444 KBytes       
[  5]  14.00-15.00  sec  30.0 MBytes   252 Mbits/sec    0    492 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-15.00  sec   505 MBytes   283 Mbits/sec  672             sender
[  5]   0.00-15.06  sec   502 MBytes   280 Mbits/sec                  receiver

iperf Done.

```
Проверяем в режиме tun:
```
TASK [Wait for handle tun-test] ***********************************************************************************************
[Wait for handle tun-test]
Press Enter to continue (if test is ready):
7: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 500
    link/none 
    inet 10.10.10.1/24 scope global tun0
       valid_lft forever preferred_lft forever
5: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 500
    link/none 
    inet 10.10.10.2/24 scope global tun0
       valid_lft forever preferred_lft forever

root@ovpn-server:~# iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 10.10.10.2, port 56962
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 56970
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  22.6 MBytes   189 Mbits/sec                  
[  5]   1.00-2.00   sec  22.5 MBytes   188 Mbits/sec                  
[  5]   2.00-3.00   sec  27.0 MBytes   226 Mbits/sec                  
[  5]   3.00-4.00   sec  26.6 MBytes   223 Mbits/sec                  
[  5]   4.00-5.00   sec  27.0 MBytes   226 Mbits/sec                  
[  5]   5.00-6.00   sec  26.6 MBytes   223 Mbits/sec                  
[  5]   6.00-7.00   sec  26.6 MBytes   223 Mbits/sec                  
[  5]   7.00-8.00   sec  27.3 MBytes   229 Mbits/sec                  
[  5]   8.00-9.00   sec  27.0 MBytes   227 Mbits/sec                  
[  5]   9.00-10.00  sec  25.6 MBytes   215 Mbits/sec                  
[  5]  10.00-11.00  sec  26.9 MBytes   226 Mbits/sec                  
[  5]  11.00-12.00  sec  27.3 MBytes   229 Mbits/sec                  
[  5]  12.00-13.00  sec  26.7 MBytes   224 Mbits/sec                  
[  5]  13.00-14.00  sec  25.9 MBytes   218 Mbits/sec                  
[  5]  14.00-15.00  sec  18.3 MBytes   153 Mbits/sec                  
[  5]  15.00-15.05  sec   875 KBytes   154 Mbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-15.05  sec   385 MBytes   215 Mbits/sec                  receiver


root@ovpn-client:~# iperf3 -c 10.10.10.1 -t 15
Connecting to host 10.10.10.1, port 5201
[  5] local 10.10.10.2 port 56970 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  25.3 MBytes   212 Mbits/sec   25    510 KBytes       
[  5]   1.00-2.00   sec  22.7 MBytes   191 Mbits/sec  351    239 KBytes       
[  5]   2.00-3.00   sec  26.6 MBytes   223 Mbits/sec   93    173 KBytes       
[  5]   3.00-4.00   sec  26.6 MBytes   223 Mbits/sec   30    123 KBytes       
[  5]   4.00-5.00   sec  27.4 MBytes   230 Mbits/sec   25    184 KBytes       
[  5]   5.00-6.00   sec  26.6 MBytes   223 Mbits/sec   44    193 KBytes       
[  5]   6.00-7.00   sec  26.6 MBytes   223 Mbits/sec   40    223 KBytes       
[  5]   7.00-8.00   sec  27.4 MBytes   230 Mbits/sec   45    225 KBytes       
[  5]   8.00-9.00   sec  26.7 MBytes   224 Mbits/sec   61    229 KBytes       
[  5]   9.00-10.00  sec  25.8 MBytes   216 Mbits/sec   86    168 KBytes       
[  5]  10.00-11.00  sec  27.4 MBytes   230 Mbits/sec   38    161 KBytes       
[  5]  11.00-12.00  sec  26.7 MBytes   224 Mbits/sec   13    170 KBytes       
[  5]  12.00-13.00  sec  27.4 MBytes   230 Mbits/sec   39    180 KBytes       
[  5]  13.00-14.00  sec  25.0 MBytes   209 Mbits/sec   59    189 KBytes       
[  5]  14.00-15.00  sec  18.5 MBytes   155 Mbits/sec   15    159 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-15.00  sec   387 MBytes   216 Mbits/sec  964             sender
[  5]   0.00-15.05  sec   385 MBytes   215 Mbits/sec                  receiver

iperf Done.
```

Проверяем RAS на базе OpenVPN:
```
$ sudo openvpn --config host-ras/client.conf

$ ip r
default via 192.168.0.1 dev wlp0s20f3 proto dhcp src 192.168.0.122 metric 600 
10.10.10.0/24 via 10.10.10.1 dev tun0 
10.10.10.0/24 dev tun0 proto kernel scope link src 10.10.10.2 
192.168.0.0/24 dev wlp0s20f3 proto kernel scope link src 192.168.0.122 metric 600 
192.168.56.0/24 dev vboxnet0 proto kernel scope link src 192.168.56.1 

$ ip a
10: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 500
    link/none 
    inet 10.10.10.2/24 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::561a:4189:e3df:6f52/64 scope link stable-privacy 
       valid_lft forever preferred_lft forever

$ ping 10.10.10.1
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=413 ttl=64 time=1.59 ms
64 bytes from 10.10.10.1: icmp_seq=414 ttl=64 time=1.57 ms
64 bytes from 10.10.10.1: icmp_seq=415 ttl=64 time=2.08 ms
64 bytes from 10.10.10.1: icmp_seq=416 ttl=64 time=1.35 ms
64 bytes from 10.10.10.1: icmp_seq=417 ttl=64 time=2.12 ms
64 bytes from 10.10.10.1: icmp_seq=418 ttl=64 time=0.487 ms
64 bytes from 10.10.10.1: icmp_seq=419 ttl=64 time=1.04 ms
64 bytes from 10.10.10.1: icmp_seq=420 ttl=64 time=1.99 ms
64 bytes from 10.10.10.1: icmp_seq=421 ttl=64 time=1.57 ms
```
