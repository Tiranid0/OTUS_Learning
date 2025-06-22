### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №6 - Практические навыки работы с ZFS**  
**Цель** - Научится самостоятельно устанавливать ZFS, настраивать пулы, изучить основные возможности ZFS. 

**Задание:**
1) Определить алгоритм с наилучшим сжатием:
   - создать 4 файловых системы на каждой применить свой алгоритм сжатия;
   - для сжатия использовать либо текстовый файл, либо группу файлов.
2) Определить настройки пула.
   С помощью команды zfs import собрать pool ZFS.
   Командами zfs определить настройки:
   - размер хранилища;
   - тип pool;
   - значение recordsize;
   - какое сжатие используется;
3) Работа со снапшотами:
   скопировать файл из удаленной директории;
   восстановить файл локально. zfs receive;
   найти зашифрованное сообщение в файле secret_message.
   
**Критерии:**  
1) Сcылка на репозиторий GitHub.
2) Vagrantfile с Bash-скриптом, который будет конфигурировать сервер.
3) Документация по каждому заданию:
   Создайте файл README.md и снабдите его следующей информацией:
   - название выполняемого задания;
   - текст задания;
   - описание команд и их вывод;
   - особенности проектирования и реализации решения;
   - заметки, если считаете, что имеет смысл их зафиксировать в репозитории.

****
#### **Описание реализации:**  
Реализация выполнена согласно описанным в методическом указании шагам: [https://docs.google.com/document/d/1jTq4l4UD1CF9C_VFqGXZYunXA2RUap70CfKm_6OXZBU/edit?tab=t.0](https://docs.google.com/document/d/1xursgUsGDVTLh4B_r0XGw_flPzd5lSJ0nfMFL-HQmFs/edit?tab=t.0) \
Шаги "описание команд и их вывод" (см. комменатрии в скрипте) и "особенности проектирования и реализации решения" упущены, т.к. реализация полностью повторяет методическое указание.
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
Скрипт bash запускается сразу при включении виртуальной машины. \
Результат выполенния bash_prov-result.txt\
Для запуска ansible-playbook предварительно, перед запуском виртуальной машины, закомментировать строку с bash и расскомментировать с ansible:
```
config.vm.provision "shell", path: "bash_zfs.sh"
#config.vm.provision "ansible" do |ansible|
#      ansible.playbook = "zfs.yml"
#end
```
Результат выполенения плейбука ansible_prov-result.txt
