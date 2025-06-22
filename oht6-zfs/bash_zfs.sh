#!/bin/bash

sudo apt update

echo ""
echo "Определение алгоритма с наилучшим сжатием"
echo ""

#Смотрим список дисков в системе
echo ""
echo "Смотрим список дисков в системе"
echo ""
lsblk

#Установим пакет утилит для ZFS
echo ""
echo "Установим пакет утилит для ZFS"
echo ""
sudo apt install -y zfsutils-linux

#Создаём 4 пула из двух дисков в режиме RAID 1
echo ""
echo "Создаём 4 пула из двух дисков в режиме RAID 1"
echo ""
sudo zpool create otus1 mirror /dev/sdb /dev/sdc
sudo zpool create otus2 mirror /dev/sdd /dev/sde
sudo zpool create otus3 mirror /dev/sdf /dev/sdg
sudo zpool create otus4 mirror /dev/sdh /dev/sdi

#Смотрим информацию о пулах
echo ""
echo "Смотрим информацию о пулах"
echo ""
sudo zpool list
sudo zpool status

#Добавим разные алгоритмы сжатия в каждую файловую систему
echo ""
echo "Добавим разные алгоритмы сжатия в каждую файловую систему"
echo ""
sudo zfs set compression=lzjb otus1
sudo zfs set compression=lz4 otus2
sudo zfs set compression=gzip-9 otus3
sudo zfs set compression=zle otus4

#Проверим, что все файловые системы имеют разные методы сжатия
echo ""
echo "Проверим, что все файловые системы имеют разные методы сжатия"
echo ""
sudo zfs get all | grep compression

#Скачаем один и тот же текстовый файл во все пулы
echo ""
echo "Скачаем один и тот же текстовый файл во все пулы"
echo ""
for i in {1..4}; do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done

#Проверим, что файл был скачан во все пулы
echo ""
echo "Проверим, что файл был скачан во все пулы"
echo ""
ls -l /otus*
#Проверим, сколько места занимает один и тот же файл в разных пулах и проверим степень сжатия файлов
echo ""
echo "Проверим, сколько места занимает один и тот же файл в разных пулах и проверим степень сжатия файлов"
echo ""
sudo zfs list
zfs get all | grep compressratio | grep -v ref


echo ""
echo "Определение настроек пула"
echo ""


#Скачиваем архив в домашний каталог
echo ""
echo "Скачиваем архив в домашний каталог"
echo ""
wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'

#Разархивируем его:
echo ""
echo "Разархивируем его:"
echo ""
tar -xzvf archive.tar.gz

#Проверим, возможно ли импортировать данный каталог в пул:
echo ""
echo "Проверим, возможно ли импортировать данный каталог в пул:"
echo ""
sudo zpool import -d zpoolexport/

#Сделаем импорт данного пула к нам в ОС:
echo ""
echo "Сделаем импорт данного пула к нам в ОС:"
echo ""
sudo zpool import -d zpoolexport/ otus
sudo zpool status

#Запрос сразу всех параметром файловой системы:
echo ""
echo "Запрос сразу всех параметром файловой системы:"
echo ""
sudo zfs get all otus
echo ""
sudo zfs get available otus
echo ""
sudo zfs get readonly otus
echo ""
sudo zfs get recordsize otus
echo ""
sudo zfs get compression otus
echo ""
sudo zfs get checksum otus


echo ""
echo "Работа со снапшотом, поиск сообщения от преподавателя"
echo ""

#Скачаем файл, указанный в задании:
echo ""
echo "Скачаем файл, указанный в задании:"
echo ""
wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download
sleep 120

#Восстановим файловую систему из снапшота:
echo ""
echo "Восстановим файловую систему из снапшота:"
echo ""
sudo zfs receive otus/test@today < otus_task2.file

#Далее, ищем в каталоге /otus/test файл с именем “secret_message”:
echo ""
echo "Далее, ищем в каталоге /otus/test файл с именем “secret_message”:"
echo ""
sudo find /otus/test -name "secret_message" /otus/test/task1/file_mess/secret_message


#Смотрим содержимое найденного файла:
echo ""
echo "Смотрим содержимое найденного файла:"
echo ""
sudo cat /otus/test/task1/file_mess/secret_message

