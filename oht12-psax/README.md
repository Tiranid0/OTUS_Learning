### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №12 - Работа с процессами.**  
**Цель** - Работать с процессами.

**Задание:**\
Написать свою реализацию ps ax используя анализ /proc
Результат ДЗ - рабочий скрипт который можно запустить

****
#### **Описание реализации:**  
Скрипт отрабатывает аналогичено команде ps -ax.

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
(полный вывод в psax_res.txt)
```
$ sudo ./psax.sh
PID	TTY	STAT	TIME	COMMAND
1	?	S	00:00	/sbin/init=
2	?	S	00:00	[kthreadd]
3	?	I	00:00	[rcu_gp]
4	?	I	00:00	[rcu_par_gp]
5	?	I	00:00	[slub_flushwq]
6	?	I	00:00	[netns]
7	?	I	00:00	[kworker/0:0-cgroup_destroy]
8	?	I	00:00	[kworker/0:0H-events_highpri]
10	?	I	00:00	[mm_percpu_wq]
11	?	S	00:00	[rcu_tasks_rude_]
12	?	S	00:00	[rcu_tasks_trace]
13	?	S	00:00	[ksoftirqd/0]
14	?	I	00:00	[rcu_sched]
15	?	S	00:00	[migration/0]
16	?	S	00:00	[idle_inject/0]
...
```
