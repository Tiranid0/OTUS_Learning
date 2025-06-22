#!/bin/bash

shopt -s -o noclobber

#Заголовки таблицы
printf "PID\tTTY\tSTAT\tTIME\tCOMMAND\n"

#Получаем номера всех PID 
pids=$(ls -1 /proc/ | grep [0-9] | sort -n)

#Далее начинаем заполнять каждый столбик таблицы 
for pid in ${pids[@]}; do

    #TTY
    tty="$(sudo readlink /proc/$pid/fd/0)"
    tty="${tty#/dev/}"
    if [ -z "$tty" ] || [ "$tty" == "null" ]; then 
        tty="?"
    fi

    #STAT
    if [ -e "/proc/$pid/status" ]; then
        stat=$(cat /proc/$pid/status | grep "State" | awk '{print $2}')
    fi

    #TIME
    if [ -e "/proc/$pid/stat" ]; then
        utime=$(awk '{print $14}' "/proc/$pid/stat")
        stime=$(awk '{print $15}' "/proc/$pid/stat")
        time=$((utime + stime))
        minutes=$((cpu_time / 60))
        seconds=$((cpu_time % 60))
        time=$(printf "%02d:%02d" "$minutes" "$seconds")
    fi

    #COMMAND
    if [ -e "/proc/$pid/cmdline" ]; then
        command=$(cat /proc/$pid/cmdline | tr -d '\0')
    fi
    if [ -z "$command" ]; then
        command=$(head -1 /proc/$pid/status | awk '{print "["$2"]"}')
    fi

    printf "%d\t%s\t%s\t%s\t%s\n" "$pid" "$tty" "$stat" "$time" "$command"
    
done
