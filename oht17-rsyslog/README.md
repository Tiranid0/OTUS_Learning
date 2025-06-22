### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №17 - Настраиваем центральный сервер для сбора логов.**  
**Цель** - Научится проектировать централизованный сбор логов и рассмотреть особенности разных платформ для сбора логов..

**Задание:**  
в вагранте поднимаем 2 машины web и log
на web поднимаем nginx
на log настраиваем центральный лог сервер на любой системе на выбор
journald;
rsyslog;
elk.
настраиваем аудит, следящий за изменением конфигов нжинкса
Все критичные логи с web должны собираться и локально и удаленно.
Все логи с nginx должны уходить на удаленный сервер (локально только критичные).
Логи аудита должны также уходить на удаленную систему.

****
#### **Описание реализации:**  
Сделано достойно документу (как и курсу) ниже: \
https://docs.google.com/document/d/16UBAMu4LYqvRv6PmCeHcmOampMrIZavH/edit?tab=t.0 \
Машины настраиваются через ansible, проверяются вручную. \ 
Стенд включает в себя 3 машины:
1) Веб-сервер nginx;
2) Rsyslog-сервер для сбора всех логов;
3) Rsyslog-сервер для сбора всех остальных логов.
***
##### Подготовка стенда.
Параметры стенда:
```
VBox - generic/ubuntu2204 (версия generic/ubuntu2204)
ansible [core 2.16.3]
python version = 3.12.3
jinja version = 3.1.2
Vagrant 2.4.3
VirtualBox v.7.0.26 r168464
```
Вклчюаем сервер и проверяем статус машин:
```
vagrant up

vagrant status
Current machine states:

web                       running (virtualbox)
log-elk-nginx             running (virtualbox)
log-all                   running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```
Запускаем ansible-playbook:
```
ansible-playbook -i hosts rsyslog.yml
```

***
##### Проверка логов
Заходим на сервер log-all и проверяем наличие логов:
```
root@log-all:~# ls /var/log/rsyslog/192.168.56.10/
apparmor.systemd.log              .log                              systemd-fsck.log
apport.log                        lvm.log                           systemd-hostnamed.log
audisp-remote.log                 lxd.activate.log                  systemd-journald.log
auditd.log                        ModemManager.log                  systemd.log
audit.log                         multipathd.log                    systemd-logind.log
augenrules.log                    networkd-dispatcher.log           systemd-modules-load.log
cron.log                          nginx.log                         systemd-networkd.log
CRON.log                          PackageKit.log                    systemd-networkd-wait-online.log
dbus-daemon.log                   polkitd.log                       systemd-resolved.log
fwupdmgr.log                      python3.log                       systemd-timedated.log
haveged.log                       rsyslogd.log                      systemd-timesyncd.log
ifplugd(eth0).log                 snapd-apparmor.log                systemd-udevd.log
ifplugd.log                       snapd.log                         virtualbox-guest-utils.log
journal.log                       sshd.log                          
kernel.log                        sudo.log
```

Заходим на сервер log-nginx и проверяем наличие логов:
```
root@log-nginx:~# ls /var/log/rsyslog/192.168.56.10/
nginx_access.log
root@log-nginx:~# cat /var/log/rsyslog/192.168.56.10/nginx_access.log 
Apr 28 23:28:54 web nginx_access: 192.168.56.1 - - [28/Apr/2025:23:28:54 +0300] "GET / HTTP/1.1" 200 396 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:137.0) Gecko/20100101 Firefox/137.0"
Apr 28 23:28:54 web nginx_access: 192.168.56.1 - - [28/Apr/2025:23:28:54 +0300] "GET /favicon.ico HTTP/1.1" 404 134 "http://192.168.56.10/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:137.0) Gecko/20100101 Firefox/137.0"
Apr 28 23:29:22 web nginx_access: 192.168.56.1 - - [28/Apr/2025:23:29:22 +0300] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:137.0) Gecko/20100101 Firefox/137.0"
Apr 28 23:29:22 web nginx_access: 192.168.56.1 - - [28/Apr/2025:23:29:22 +0300] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:137.0) Gecko/20100101 Firefox/137.0"
Apr 28 23:29:23 web nginx_access: 192.168.56.1 - - [28/Apr/2025:23:29:23 +0300] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:137.0) Gecko/20100101 Firefox/137.0"

root@log-nginx:~# ls /var/log/rsyslog/192.168.56.10/
nginx_access.log  nginx_error.log
root@log-nginx:~# cat /var/log/rsyslog/192.168.56.10/nginx_error.log 
Apr 28 23:30:42 web nginx_error: 2025/04/28 23:30:42 [error] 15653#15653: *3 directory index of "/var/www/html/" is forbidden, client: 192.168.56.1, server: _, request: "GET / HTTP/1.1", host: "192.168.56.10"
Apr 28 23:30:42 web nginx_error: 2025/04/28 23:30:42 [error] 15653#15653: *3 directory index of "/var/www/html/" is forbidden, client: 192.168.56.1, server: _, request: "GET / HTTP/1.1", host: "192.168.56.10"
Apr 28 23:30:43 web nginx_error: 2025/04/28 23:30:43 [error] 15653#15653: *3 directory index of "/var/www/html/" is forbidden, client: 192.168.56.1, server: _, request: "GET / HTTP/1.1", host: "192.168.56.10"
Apr 28 23:30:43 web nginx_error: 2025/04/28 23:30:43 [error] 15653#15653: *3 directory index of "/var/www/html/" is forbidden, client: 192.168.56.1, server: _, request: "GET / HTTP/1.1", host: "192.168.56.10"
Apr 28 23:30:43 web nginx_error: 2025/04/28 23:30:43 [error] 15653#15653: *3 directory index of "/var/www/html/" is forbidden, client: 192.168.56.1, server: _, request: "GET / HTTP/1.1", host: "192.168.56.10"
Apr 28 23:30:44 web nginx_error: 2025/04/28 23:30:44 [error] 15653#15653: *3 directory index of "/var/www/html/" is forbidden, client: 192.168.56.1, server: _, request: "GET / HTTP/1.1", host: "192.168.56.10"
Apr 28 23:30:44 web nginx_error: 2025/04/28 23:30:44 [error] 15653#15653: *3 directory index of "/var/www/html/" is forbidden, client: 192.168.56.1, server: _, request: "GET / HTTP/1.1", host: "192.168.56.10"
Apr 28 23:30:44 web nginx_error: 2025/04/28 23:30:44 [error] 15653#15653: *3 directory index of "/var/www/html/" is forbidden, client: 192.168.56.1, server: _, request: "GET / HTTP/1.1", host: "192.168.56.10"
Apr 28 23:30:45 web nginx_error: 2025/04/28 23:30:45 [error] 15653#15653: *3 directory index of "/var/www/html/" is forbidden, client: 192.168.56.1, server: _, request: "GET / HTTP/1.1", host: "192.168.56.10"
Apr 28 23:30:45 web nginx_error: 2025/04/28 23:30:45 [error] 15653#15653: *3 directory index of "/var/www/html/" is forbidden, client: 192.168.56.1, server: _, request: "GET / HTTP/1.1", host: "192.168.56.10"

root@web:~# chmod +x /etc/nginx/nginx.conf 
root@web:~# chmod +x /etc/nginx/nginx.conf 
root@web:~# chmod +x /etc/nginx/nginx.conf 

root@log-nginx:~# cat /var/log/audit/audit.log 
Apr 29 00:28:02 web audit[20770]: SYSCALL arch=c000003e syscall=268 success=yes exit=0 a0=ffffff9c a1=558f3b9d8500 a2=1ed a3=0 items=1 ppid=20761 pid=20770 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=36 comm="chmod" exe="/usr/bin/chmod" subj=unconfined key="nginx_config"
Apr 29 00:28:03 web audit[20771]: SYSCALL arch=c000003e syscall=268 success=yes exit=0 a0=ffffff9c a1=562c373b1500 a2=1ed a3=0 items=1 ppid=20761 pid=20771 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=36 comm="chmod" exe="/usr/bin/chmod" subj=unconfined key="nginx_config"
Apr 29 00:32:55 web audit[20818]: SYSCALL arch=c000003e syscall=268 success=yes exit=0 a0=ffffff9c a1=55b59cc34500 a2=1ed a3=0 items=1 ppid=20761 pid=20818 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=36 comm="chmod" exe="/usr/bin/chmod" subj=unconfined key="nginx_config"
Apr 29 00:32:56 web audit[20819]: SYSCALL arch=c000003e syscall=268 success=yes exit=0 a0=ffffff9c a1=55f91e409500 a2=1ed a3=0 items=1 ppid=20761 pid=20819 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=36 comm="chmod" exe="/usr/bin/chmod" subj=unconfined key="nginx_config"
Apr 29 00:32:56 web audit[20820]: SYSCALL arch=c000003e syscall=268 success=yes exit=0 a0=ffffff9c a1=55c945494500 a2=1ed a3=0 items=1 ppid=20761 pid=20820 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=36 comm="chmod" exe="/usr/bin/chmod" subj=unconfined key="nginx_config"
```
