#!/bin/bash

#Имеем файл лога access.log, который парсим на предмет:
#1) Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
#2) Ошибки веб-сервера/приложения c момента последнего запуска;
#3) Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта.
#4) Скрипт должен предотвращать одновременный запуск нескольких копий, до его завершения.

#Директония для хранения файлов работы скрипта
script_dir="$HOME/otus_bash"
#файл с временем последнего запуска
time_file="$script_dir/time_file"
#файл блокировки запуска дубля скрипта
block_file="$script_dir/block_file"
#Обозначаем, где у нас файл лога
log_file=$1

#проверяем, что сообщили о файле с логом
if [ -z "$1" ]; then
    echo "Лог-файла нету"
    exit 1
fi

#Проверяем, что скрипт уже запущен
if [ -f "$block_file" ]; then
    echo "Скрипт уже запущен"
    exit 1
fi

#Если блок-файла нет и скрипт еще не запускался, то создаем служебные файлы
mkdir -p $script_dir
touch $time_file $block_file

#Указываем, откуда брать время последнего запуска
date_time="$(cat "$time_file")"

#При первом запуске скрипт покажет логи за все время
if [ -z "$(cat time_file)" ]; then 
    date_time="2000-01-01T00:00:00"
fi

#Проверяем текущее время
now_time=$(date --iso-8601=seconds)

#номер строки, с которого читаем лог
line=1

#если читаем не с первой строки, то
function line_counter {
    tail +$line $log_file
}    

#преобразуем дату
time_point=$(date -d "$date_time" +"%s")

#ищем в логе дату и строку
while IFS= read -r log_string
do 
    ((line++))

    #извлекаем дату_время из полученной строки
    string_date_time=$(echo "$log_string" | grep -oP '\[\K[^]]+' | sed 's/\// /g; s/:/ /')
    
    #преобразуем  аналогично time_point
    log_time_point=$(date -d "$string_date_time" +"%s")

    #сравниваем время
    if [ "$log_time_point" -ge "$time_point" ]; then
        break
    fi

done < "$log_file"

echo "script report"
echo "====="
echo "Log from $date_time to $now_time"
echo
echo "5 most popular IPs"
echo "====="
line_counter | awk '{print $1}' | uniq -c | sort -nr | head -n 5

echo
echo "4 most popular requests"
echo "====="
line_counter | egrep '(GET|POST)\s/\S?+' -o | sort | uniq -c | sort -nr | head -n 5

echo
echo "Top server-errors-requests"
echo "====="
line_counter | egrep '(GET|POST).*(HTTP/[0-9].[0-9])" 5[0-9]{2}' -o | sort | uniq -c | sort -nr

echo
echo "HTTP-codes"
echo "====="
line_counter | egrep '(GET|POST).*(HTTP/[0-9].[0-9])" [0-9]{3}' -o | awk '{print $4}' | sort | uniq -c | sort -nr

#обновляем дату_время в файле с датой_временем последнего выполнения скрипта
echo $now_time > $time_file

#в конце выполнения скрипта удаляем файл-блокер
rm $block_file