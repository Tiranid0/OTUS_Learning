### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №9 - Работа с загрузчиком**  
**Цель** - Научиться попадать в систему без пароля;\
Устанавливать систему с LVM и переименовывать в VG.

**Задание:**\  
1) Включить отображение меню Grub.
2) Попасть в систему без пароля несколькими способами.
3) Установить систему с LVM, после чего переименовать VG.



****
#### **Описание реализации:**  
Реализация выполнена согласно описанным в методическом указании шагам: [[[https://docs.google.com/document/d/1jTq4l4UD1CF9C_VFqGXZYunXA2RUap70CfKm_6OXZBU/edit?tab=t.0](https://docs.google.com/document/d/1Xz7dCWSzaM8Q0VzBt78K3emh7zlNX3C-Q27B6UuVexI/edit?tab=t.0#heading=h.csr8pmcyj3iq)](https://docs.google.com/document/d/1wXZLFDG7NSsrmeSmL0qqec6H9CFAYIolDfiFbDa2WBU/edit?tab=t.0)](https://docs.google.com/document/d/1fRE_BFi-sFuLUUXKC8WHeGrFtPDXlTWznFgj3Z-xBM8/edit?tab=t.0) \
Дз выполнено вручную. \


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

***
##### Включить отображение меню Grub.
Редактируем файл /etc/default/grub:
```
root@ubuntu2204:~# nano /etc/default/grub
-
#GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=10
-
root@ubuntu2204:~# update-grub
-
Sourcing file `/etc/default/grub'
Sourcing file `/etc/default/grub.d/init-select.cfg'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.15.0-91-generic
Found initrd image: /boot/initrd.img-5.15.0-91-generic
Warning: os-prober will not be executed to detect other bootable partitions.
Systems on them will not be added to the GRUB boot configuration.
Check GRUB_DISABLE_OS_PROBER documentation entry.
done
-
```


***
##### Попасть в систему без пароля несколькими способами.
**1 - init=/bin/bash:**  \
Перезагружаем систему и попадаем меню grub.\
Далее через клавишу "е" попадаем в окно редактиварония загрузки и добавляем в конец строки linux... init=/bin/bash:
```
linux  /vmlinuz-5.15.0-91-generic root=/dev/mapper/ubuntu-vg-ubuntu--lv ro = net.ifnames=o biosdevname=0 init=/bin/bash
```
Нажимает Ctrl+x или F10 для загрузки, перемонтируем систему для записи и меняем пароль на пользователе:
```
root@(none):/# mount -o remount,rw /
root@(none):/# passwd vagrant
New password:
Retype new password:
passwd: password updated successfully
```

**2 - Recovery mode:**  \
Перезагружаем систему и попадаем меню grub.\
Выбираем Advanced options - > (recovery mode) \
В этом меню сначала включаем поддержку сети (network) для того, чтобы файловая система перемонтировалась в режим read/write (либо это можно сделать вручную).
Далее выбираем пункт root и попадаем в консоль с пользователем root. Если вы ранее устанавливали пароль для пользователя root (по умолчанию его нет), то необходимо его ввести. 
В этой консоли можно производить любые манипуляции с системой. \
Повторяем смену пароля из предыдущего пункта.


***
##### Установить систему с LVM, после чего переименовать VG.
Смотрим текущее состояние системы:
```
root@ubuntu2204:~# vgs
  VG        #PV #LV #SN Attr   VSize    VFree 
  ubuntu-vg   1   1   0 wz--n- <126.00g 63.00g
```
Переименовываем:
```
root@ubuntu2204:~# vgrename ubuntu-vg ubuntu-otus

  Volume group "ubuntu-vg" successfully renamed to "ubuntu-otus"
```
Далее правим /boot/grub/grub.cfg. Везде заменяем старое название VG на новое (в файле дефис меняется на два дефиса ubuntu--vg ubuntu--otus).\
После чего можем перезагружаться и, если все сделано правильно, успешно грузимся с новым именем Volume Group и проверяем:
```
root@ubuntu2204:~# vgs
  VG          #PV #LV #SN Attr   VSize    VFree 
  ubuntu-otus   1   1   0 wz--n- <126.00g 63.00g
```
