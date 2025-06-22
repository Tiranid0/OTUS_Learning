### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №2 - Vagrant. Обновить ядро в базовой системе.**  
**Цель** - Получить навыки работы с Git, Vagrant. Обновлять ядро в ОС Linux.

**Критерии:**  
1) Ссылка на репозиторий GitHub в котором находятся файлы указанные в последующих пунктах.
2) Vagrantfile, который будет разворачивать виртуальную машину в которой вы обновляли ядро.
3) Документация по каждому заданию:
4) Создайте файл README.md и снабдите его следующей информацией:
- название выполняемого задания;
- текст задания;
- особенности проектирования и реализации решения,
- заметки, если считаете, что имеет смысл их зафиксировать в репозитории.

****
#### **Описание реализации:**  
##### Подготовка стенда Vagrant.
На данном этапе производится подготовка стенда Vagrant.\
https://portal.cloud.hashicorp.com/vagrant/discover/generic/ubuntu2204 - ссылка на официальное облако Vagrant c готовым vagrant-box c Ubuntu 22.04.
1. Создаем каталог для проекта Vargant и переходим в него:\
`$ mkdir o_ht-2 && cd o_ht-2`
2. Инициализируем проект Vagrant. В результате выполения команды будет скачан vagrant-box с официального облака Hashicorp и создан Vagrantfile:\
`$  vagrant init generic/ubuntu2204 --box-version 4.3.12`
3. Полученный Vagrantfile приводим к следующему виду:
```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"
  config.vm.box_version = "4.3.12"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = "2"
  end
end
```
4. Запускаем виртуальную машину и подключаемся к ней по ssh:
```
$ vagrant up
$ vagrant ssh
```
5. Приступаем к обновлению ядра.
***
##### 1 - Обновление ядра через update&upgrade.
1. После включения виртуальной машины проверяем информацию о системе:
```
 $ uname -a
Linux ubuntu2204.localdomain 5.15.0-91-generic #101-Ubuntu SMP Tue Nov 14 13:30:08 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
```
2. Проводим стандартную процедуру обновления информации о доступных пакетах обновлений и само обновление:\
` $ sudo apt update && sudo apt upgrade -y`
3. После обновления перезагружаем платформу и проверяем версию ядра:
```
$ uname -a
Linux ubuntu2204.localdomain 5.15.0-131-generic #141-Ubuntu SMP Fri Jan 10 21:18:28 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

Таким образом, произошло обновление с версии 5.15.0-91-generic на 5.15.0-131-generic. 
Но хочется чего-то большего. Попробуем второй способ.
***
##### 2 - Обновление ядра через apt install linux-image
1. Проверим, какие версии ядер поновее есть в доступе через пакетный менеджер apt (например, 5.19.0):
```
$ apt search linux-image-5.19.0
Sorting... Done
Full Text Search... Done
linux-image-5.19.0-1010-nvidia/jammy-updates,jammy-security 5.19.0-1010.10 amd64
  Signed kernel image nvidia

linux-image-5.19.0-1010-nvidia-lowlatency/jammy-updates,jammy-security 5.19.0-1010.10 amd64
  Signed kernel image nvidia-lowlatency

........

linux-image-5.19.0-46-generic/jammy-updates,jammy-security 5.19.0-46.47~22.04.1 amd64
  Signed kernel image generic

linux-image-5.19.0-50-generic/jammy-updates,jammy-security 5.19.0-50.50 amd64
  Signed kernel image generic
```
2. Из данного списка (сокращен для удобства представления примера) выбираем понравившуюся доступную версию и устанавливаем её:\
` $ sudo apt install linux-image-5.19.0-50-generic`
3. Перезагружаем систему и проверяем версию ядра:
```
$ uname -a
Linux ubuntu2204.localdomain 5.19.0-50-generic #50-Ubuntu SMP PREEMPT_DYNAMIC Mon Jul 10 18:24:29 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
```

Данным способом обновились с 5.15.0-131-generic на  5.19.0-50-generic
Но говорят, что уже есть ядра 6й версии...
***
##### 3 - Обновление ядра через скачивание dep-пакетов и их установку.
1. На сайте https://kernel.ubuntu.com/mainline выбираем версию ядра для установки (например, 6.1).
2. Скачиваем 4 deb-файла:
```
wget https://kernel.ubuntu.com/mainline/v6.1/amd64/linux-headers-6.1.0-060100-generic_6.1.0-060100.202303090726_amd64.deb
wget https://kernel.ubuntu.com/mainline/v6.1/amd64/linux-headers-6.1.0-060100_6.1.0-060100.202303090726_all.deb
wget https://kernel.ubuntu.com/mainline/v6.1/amd64/linux-image-unsigned-6.1.0-060100-generic_6.1.0-060100.202303090726_amd64.deb
wget https://kernel.ubuntu.com/mainline/v6.1/amd64/linux-modules-6.1.0-060100-generic_6.1.0-060100.202303090726_amd64.deb
```
3. Выполняем установку через dpkg:\
`$ sudo dpkg -i linux-headers* linux-image* linux-modules*`
4. Обновляем grub:\
`$ sudo update-grub`
5. Перезагружаем систему и проверяем версию ядра:
```
$ uname -a
Linux ubuntu2204.localdomain 6.1.0-060100-generic #202303090726 SMP PREEMPT_DYNAMIC Thu Mar  9 12:33:28 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
```

Обновились с 5.19.0-50-generic на 6.1.0-060100-generic.
А теперь попытаемся собрать ядро самой последней версии из исходников.
***
##### 4 - Обновление ядра через компиляцию из исходников.
Руководства:\
https://wiki.merionet.ru/articles/poshagovoe-rukovodstvo-kak-sobrat-yadro-linux-s-nulya\
https://help.ubuntu.ru/wiki/сборка_ядра\
1. На сайте https://www.kernel.org/ проверяем последнюю версию ядра. В нашем случае это 6.13.1:\
`$ wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.13.1.tar.xz`
2. Делаем распаковку исходников и переходим в каталог с исходниками:\
`$ tar xvf linux-6.13.1.tar.xz && cd  linux-6.13.1.tar.xz`
3. Копируем текущий конфиг ядра в папку с исходниками:\
`$ cp -v /boot/config-$(uname -r) .config`
4. Мы конечно можем внести изменения вручную (menuconfig), но зачем нам это (еще сломаем что-то...)? Поэтому оставляем конфиг без изменений, ведь "если работает, то не трогай" (oldconfig):\
`$ make oldconfig`
5. Просим систему не проверять ключи, и начинаем компиляцию ядра (на одном ядре процесс занял часов 6-7):
```
$ scripts/config --disable SYSTEM_TRUSTED_KEYS
$ scripts/config --disable SYSTEM_REVOCATION_KEYS

$ make
```
6. Собираем модули ядра:\
`$ sudo make modules_install`
7. Устанавливаем собранное ядро:\
`$ sudo make install`
8. Перезагружаем систему и проверяем версию ядра (здесь, при включении, система может сказать, что ей не хватает памяти для работы. Поэтому потребуется поправить Vagrantfile и выделить 8GB ОЗУ):
```
$ uname -a
Linux ubuntu2204.localdomain 6.13.1 #1 SMP PREEMPT_DYNAMIC Sun Feb  2 12:18:26 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

Вот мы обновились с 6.1.0-060100-generic на 6.13.1. Итого пройден путь с 5.15.0-91 до 6.13.1.
