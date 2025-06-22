#Определяем базовый образ Nginx на Alpine
FROM nginx:alpine
#Обновляем пакеты (зачем? но ладно...)
RUN apk update && apk upgrade
#Удаляем дефолтную стартовую страницу
RUN rm -rf /usr/share/nginx/html/*
#Копируем заранее подготовленную стартовую страницу
COPY  index.html /usr/share/nginx/html/
#Явно указываем порт
EXPOSE 80
#Команда запуска Nginx - не даем ему уйти в фон
CMD ["nginx", "-g", "daemon off;"]

