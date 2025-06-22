### **Otus - Administrator Linux. Professional.**  
#### **ДЗ №14 - Docker.**  
**Цель** - Разобраться с основами docker, с образом, эко системой docker в целом.

**Критерии:**  
Статус "Принято" ставится при выполнении следующих требований:
1) Создан свой кастомный образ nginx на базе alpine.
2) После запуска nginx должен отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx).
3) Определена разница между контейнером и образом, написан вывод.
4) Написан ответ на вопрос: Можно ли в контейнере собрать ядро?
5) Собранный образ запушин в docker hub и дана ссылка на репозиторий.

****
#### **Описание реализации:**  
"Методичка" - https://docs.google.com/document/d/1C0Fh88WwLJItBTrriBL-DXdO4apBi2zQeqm0PHYL4Sc/edit?tab=t.0 \
Сначала выполнено вручную согласно данному тексту, затем реализовано через ansible. \
Для проверки ansible требуется закомментировать/удалить строки провижина в Vagrantfile.
***
##### Подготовка стенда.
Параметры стенда:
```
VBox - generic/ubuntu2204 (версия generic/ubuntu2204)
ansible [core 2.16.3]
python version = 3.12.3
jinja version = 3.1.2
Vagrant 2.4.3
VirtualBox v.7.0.26 r168464
```
Поднимаем виртуальную машину и сразу через провижининг устанавливаем в нее docker согласно предложенной инструкции [https://docs.docker.com/engine/install/ubuntu/#installation-methods ](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository).
\
***
##### Готовим образ.
Делаем следующие шаги:
1) Создаем директорию custom-image, где будем хранить все связанные с контейнером файлы;
2) Готовим файлик index.html со стартовой страницей;
3) Готовим Dockerfile;
4) Собираем образ командой:
```
vagrant@ubuntu2204:~/custom-image$ docker build -t nginx-image .
[+] Building 2.2s (9/9) FINISHED                                            docker:default
 => [internal] load build definition from Dockerfile                                  0.0s
 => => transferring dockerfile: 625B                                                  0.0s
 => [internal] load metadata for docker.io/library/nginx:alpine                       0.6s
 => [internal] load .dockerignore                                                     0.0s
 => => transferring context: 2B                                                       0.0s
 => CACHED [1/4] FROM docker.io/library/nginx:alpine@sha256:65645c7bb6a0661892a8b03b  0.0s
 => [internal] load build context                                                     0.0s
 => => transferring context: 32B                                                      0.0s
 => [2/4] RUN apk update && apk upgrade                                               1.2s
 => [3/4] RUN rm -rf /usr/share/nginx/html/*                                          0.2s
 => [4/4] COPY  index.html /usr/share/nginx/html/                                     0.1s 
 => exporting to image                                                                0.1s 
 => => exporting layers                                                               0.1s 
 => => writing image sha256:76799d5281cb8f6e5f5ea4d9009210ff71d64cbbaa40b751f087de08  0.0s 
 => => naming to docker.io/library/nginx-image                                        0.0s
```
\
***
##### Проверка.
Запускаем контейнер и проверяем страницу:
```
vagrant@ubuntu2204:~/custom-image$ docker run -d --name nginx-cont -p 8080:80 nginx-image
c48e95ddf249b8d6a23d67957441d56c31da71f3949ef65003ddffa2616b4db9
vagrant@ubuntu2204:~/custom-image$ curl -v http://localhost:8080
*   Trying 127.0.0.1:8080...
* Connected to localhost (127.0.0.1) port 8080 (#0)
> GET / HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.81.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Server: nginx/1.27.5
< Date: Thu, 17 Apr 2025 20:42:03 GMT
< Content-Type: text/html
< Content-Length: 198
< Last-Modified: Thu, 17 Apr 2025 20:21:21 GMT
< Connection: keep-alive
< ETag: "680162c1-c6"
< Accept-Ranges: bytes
< 
<!DOCTYPE html>
<html>
<head>
    <title>Custom Page</title>
</head>
<body>
    <h1>( ͡° ͜ʖ ͡°) - it's custom page. yes.</h1>
    <p>only linux-professionals can see that.</p>
</body>
</html>
* Connection #0 to host localhost left intact

```
Запуливаем данный образ на docker hub, предварительно пересобрав его с именем аккаунта (логинимся через гит и логинимся в докер через терминал) - https://hub.docker.com/r/yup26/nginx-image:
```
vagrant@ubuntu2204:~/custom-image$ docker login
---
секретные штуки
---
vagrant@ubuntu2204:~/custom-image$ docker build -t yup26/nginx-image .
[+] Building 0.9s (9/9) FINISHED                                            docker:default
 => [internal] load build definition from Dockerfile                                  0.0s
 => => transferring dockerfile: 625B                                                  0.0s
 => [internal] load metadata for docker.io/library/nginx:alpine                       0.7s
 => [internal] load .dockerignore                                                     0.0s
 => => transferring context: 2B                                                       0.0s
 => [1/4] FROM docker.io/library/nginx:alpine@sha256:65645c7bb6a0661892a8b03b89d0743  0.0s
 => [internal] load build context                                                     0.0s
 => => transferring context: 32B                                                      0.0s
 => CACHED [2/4] RUN apk update && apk upgrade                                        0.0s
 => CACHED [3/4] RUN rm -rf /usr/share/nginx/html/*                                   0.0s
 => CACHED [4/4] COPY  index.html /usr/share/nginx/html/                              0.0s
 => exporting to image                                                                0.0s
 => => exporting layers                                                               0.0s
 => => writing image sha256:76799d5281cb8f6e5f5ea4d9009210ff71d64cbbaa40b751f087de08  0.0s
 => => naming to docker.io/yup26/nginx-image                                          0.0s
vagrant@ubuntu2204:~/custom-image$ docker push yup26/nginx-image
Using default tag: latest
The push refers to repository [docker.io/yup26/nginx-image]
bbcf347ce3d7: Pushed 
7dd497de4af8: Pushed 
fb74c9a31d67: Pushed 
0d853d50b128: Pushed 
947e805a4ac7: Pushed 
811a4dbbf4a5: Pushed 
b8d7d1d22634: Pushed 
e244aa659f61: Pushed 
c56f134d3805: Pushed 
d71eae0084c1: Pushed 
08000c18d16d: Pushed 
latest: digest: sha256:7536d7780a2cc0d22224918e401e3a1c7618e2e661a205908785819045154dbc size: 2614

```
\
***
##### Ответы на вопросы.
1 - Разница между контейнером и образом:
```
Образ Docker (Docker Image) - это неизменяемый файл, содержащий исходный код, библиотеки, зависимости, инструменты и другие файлы, необходимые для запуска приложения.
Контейнер Docker (Docker Container) - это виртуализированная среда выполнения, в которой пользователи могут изолировать приложения от хостовой системы. Эти контейнеры представляют собой компактные портативные хосты, в которых можно быстро и легко запустить приложение.
Иными словами: это некий шаблон для создания контейнера, примерно как VagrantBox, а контейнер - это запущейнный экземпляр образа, как виртуальная машина, запущейнная по вагрант-боксу.
Т.е. мы можем один раз подготовить нужный нам образ со всеми необходимыми нам конфигами, а затем запускать его и изменять в отдельных контейнерах для работы с ним по разным сценариям.
```
\
2 - Можно ли в контейнере собрать ядро?
```
Можно, т.к. процесс сборки ядра - это по сути, компиляция исходного кода. Но есть ряд нюансов:
- Контейнер - это всего лишь изолированный процесс, который использует ядро и ресурсы хостовой ОС. Он не эмулирует оборудование и не запускает отдельное ядро.  Следовательно, запустить в контейнере собранное ядро нельзя. 
- Требуется достаточно ресурсов: цпу, озу и дискового пространства;
- Требуется привелигированный режим с прямым доступом к аппаратному обеспечению хоста, возможностью модификации ядра и изменения параметров системы. Однако, это требует особой осторожности и может быть небезопасным, так как предоставляет полный доступ к хостовой системе и может нарушить изоляцию контейнера.
- Для сборки и тестирования ядра лучше использовать виртуальные или физические машины с полным контролем системы.
```
