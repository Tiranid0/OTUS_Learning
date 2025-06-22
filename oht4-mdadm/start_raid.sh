#!/bin/bash

echo "Проверяем доступность дополнительных дисков"
lsblk
echo ""

echo "Создаем RAID6 и проверяем статус"
sudo mdadm --zero-superblock --force /dev/sd{b,c,d,e,f,g}
sudo mdadm --create --verbose /dev/md0 -l 6 -n 4 /dev/sd{b,c,d,e}
echo ""
sudo cat /proc/mdstat
echo ""
sudo mdadm -D  /dev/md0
echo ""

echo "Создаем конфигурационный файл mdadm.conf"
sudo mdadm --detail --scan --verbose
mkdir /etc/mdadm
sudo bash -c 'echo "DEVICE partitions" > /etc/mdadm/mdadm.conf'
sudo bash -c 'mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf'
echo ""

echo "Создаем GPT-раздел, пять партиций и монтируем их на диск"
sudo parted -s /dev/md0 mklabel gpt
sudo parted /dev/md0 mkpart primary ext4 0% 20%
sudo parted /dev/md0 mkpart primary ext4 20% 40%
sudo parted /dev/md0 mkpart primary ext4 40% 60%
sudo parted /dev/md0 mkpart primary ext4 60% 80%
sudo parted /dev/md0 mkpart primary ext4 80% 100%
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done
sudo mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do sudo mount /dev/md0p$i /raid/part$i; done
lsblk

