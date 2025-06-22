### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №4 - Работа с mdadm**  
**Цель** - научиться использовать утилиту для управления программными RAID-массивами в Linux

**Критерии:**  
1) добавить в Vagrantfile еще дисков
2) собрать R0/R5/R10 на выбор
3) прописать собранный рейд в конф, чтобы рейд собирался при загрузке
4) сломать/починить raid
5) создать GPT раздел и 5 партиций и смонтировать их на диск.
Формат сдачи - измененный Vagrantfile, скрипт для создания рейда, конф для автосборки рейда при загрузке.
**Доп. задание** - Vagrantfile, который сразу собирает систему с подключенным рейдом

Статус "Принято" ставится при выполнении следующего условия:
1) сдан измененный Vagrantfile, скрипт для создания рейда, конф для автосборки рейда при загрузке.

****
#### **Описание реализации:**  
Реализация выполнена согласно описанным в методическом указании шагам: https://docs.google.com/document/d/1jTq4l4UD1CF9C_VFqGXZYunXA2RUap70CfKm_6OXZBU/edit?tab=t.0 \
Дз выполнено через bash и ansible. \

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

nginx                     running (virtualbox)

The VM is running. To stop this VM, you can run `vagrant halt` to
shut it down forcefully, or you can run `vagrant suspend` to simply
suspend the virtual machine. In either case, to restart it again,
simply run `vagrant up`.
```
Копируем скрипт на виртуальную машину, даем права на исполнение и запускаем:
```
$ scp -P 2222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null raid.sh vagrant@127.0.0.1:/home/vagrant
Warning: Permanently added '[127.0.0.1]:2222' (ED25519) to the list of known hosts.
vagrant@127.0.0.1's password: 
raid.sh                                       100% 1985     1.5MB/s   00:00

vagrant@ubuntu2204:~$ chmod +x raid.sh 
vagrant@ubuntu2204:~$ ./raid.sh
```
Для запуска ansible-playbook используем следующую команду:
```
$ ansible-playbook -i hosts raid.yml
```

***
##### Результат.
Результат работы локального скрипта представлен в файле *bash_result.txt*. \
Результат работы ansible-playbook представлен в файле *ansible-result.txt*. \

***
##### Дополнительное задание.
Для дополнительного задания требуется расскоментировать 2 строки в Vagrantfile:
```
#chmod +x /home/vagrant/start_raid.sh
#/home/vagrant/start_raid.sh
```
Результат выполнение провижининга представлен в файле *dop_result.txt*.

