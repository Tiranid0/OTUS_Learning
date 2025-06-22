### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №3 - Первые шаги с Ansible.**  
**Цель** - Написать первые шаги с Ansible.

**Критерии:**  
Подготовить стенд на Vagrant как минимум с одним сервером. На этом сервере используя Ansible необходимо развернуть nginx со следующими условиями:
1) необходимо использовать модуль yum/apt;
2) конфигурационные файлы должны быть взяты из шаблона jinja2 с перемененными;
3) после установки nginx должен быть в режиме enabled в systemd;
4) должен быть использован notify для старта nginx после установки;
5) сайт должен слушать на нестандартном порту - 8080, для этого использовать переменные в Ansible.

Статус "Принято" ставится, если:
1) предоставлен Vagrantfile и готовый playbook/роль (инструкция по запуску стенда, если посчитаете необходимым);
2) после запуска стенда nginx доступен на порту 8080;
3) при написании playbook/роли соблюдены перечисленные в задании условия.

****
#### **Описание реализации:**  
Реализация соответствует описанным в методическом указании шагам: https://docs.google.com/document/d/1WXPY1ZBfRGjc_Dux_-oLbSjzQEZj5nDsADkrtmt6rIo/edit?tab=t.0 \
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
Предварительно готовим конфигурационный файл *ansible.cfg* , *templates/nginx.conf.j2* и inventory-файд *staging/hosts/* .

***
##### Запуск стенда и playbook.
```
$ vagrant up
$ vagrant status
Current machine states:

nginx                     running (virtualbox)

The VM is running. To stop this VM, you can run `vagrant halt` to
shut it down forcefully, or you can run `vagrant suspend` to simply
suspend the virtual machine. In either case, to restart it again,
simply run `vagrant up`.

$ ansible-playbook nginx.yml
```

***
##### Результат.
Отработка ansible:
```
$ ansible-playbook nginx.yml

PLAY [NGINX | install and configure] ******************************************************

TASK [Gathering Facts] ********************************************************************
ok: [nginx]

TASK [update] *****************************************************************************
changed: [nginx]

TASK [NGINX | Install NGINX] **************************************************************
changed: [nginx]

TASK [NGINX | Create NGINX config file from template] *************************************
changed: [nginx]

RUNNING HANDLER [restart nginx] ***********************************************************
changed: [nginx]

RUNNING HANDLER [reload nginx] ************************************************************
changed: [nginx]

PLAY RECAP ********************************************************************************
nginx                      : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
Проверка на стенде:
```
vagrant@nginx:~$ systemctl status nginx.service 
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2025-04-15 19:48:01 UTC; 1min 2s ago
       Docs: man:nginx(8)
    Process: 3145 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (cod>
    Process: 3146 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited,>
    Process: 3175 ExecReload=/usr/sbin/nginx -g daemon on; master_process on; -s reload (c>
   Main PID: 3147 (nginx)
      Tasks: 2 (limit: 710)
     Memory: 1.9M
        CPU: 9ms
     CGroup: /system.slice/nginx.service
             ├─3147 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on>
             └─3176 "nginx: worker process" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ">
lines 1-14/14 (END)
^C
vagrant@nginx:~$ curl http://192.168.56.150:8080
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

