## django-uwsgi-nginx-mxonline django-uwsgi-nginx for MxOnline
源项目地址[ link ](https://github.com/dockerfiles/django-uwsgi-nginx)
#### 目的 
这个dockerfile是我为了练习“慕学online”(MxOnline)这个项目，而更改的。使用这个dockerfile 可以方便的build一个docker来运行“慕学online”项目.里面基本把项目中要使用的django模块都安装上了。pip 默认安装的DjangoUeditor无法运行python3上，这个问题也解决掉了。
#### 系统及软件版本（只支持python3)
ubuntu 16.04
python 3.6.3
pip 9.0.1
uwsgi 2.0.17
django 1.11.6
django-crispy-forms (1.7.2)
django-formtools (2.1)
django-import-export (1.0.0)
django-pure-pagination (0.3.0)
django-ranged-response (0.2.0)
django-reversion (2.0.13)
django-simple-captcha (0.5.6)
DjangoUeditor (1.8.143)

#### 做了哪些更改
1. 更换了apt-get 的源，使用阿里云的源
2. 更换了pip的源， 使用阿里云的源
3. 使用了第三的python源，安装了python3.6.3版本
4. 安装了所有慕学online项目所要使用的django包
5. 去掉了之前对python2的支持

#### 使用方法
1. 安装docker
   [win10 pro上安装docker参考这个文章](https://m690.com/archives/1141/)
2. git clone 这个项目
    ```
   git clone https://github.com/w8833531/django-uwsgi-nginx-mxonline-mxonline.git
   ``` 
3. 运行Docker build 
    ```
    docker build -t mxonline .
    ```
4. 运行Docker run
    ```
    # C:\git\MxOnline是你慕学online项目的目录
   docker run -d --name mxonline -v C:\git\MxOnline:/home/docker/code/app -p 80:80 mxonline
   ```
5. 直接访问 http://127.0.0.1 来查看项目是否跑得正常，如果有问题，可以在/var/log/supervisor/目录中查看相关uswgi的日志

# Django, uWSGI and Nginx in a container, using Supervisord
[link](https://github.com/dockerfiles/django-uwsgi-nginx)
This Dockerfile shows you *how* to build a Docker container with a fairly standard
and speedy setup for Django with uWSGI and Nginx.

uWSGI from a number of benchmarks has shown to be the fastest server 
for python applications and allows lots of flexibility. But note that we have
not done any form of optimalization on this package. Modify it to your needs.

Nginx has become the standard for serving up web applications and has the 
additional benefit that it can talk to uWSGI using the uWSGI protocol, further
eliminating overhead. 

Most of this setup comes from the excellent tutorial on 
https://uwsgi.readthedocs.org/en/latest/tutorials/Django_and_nginx.html

The best way to use this repository is as an example. Clone the repository to 
a location of your liking, and start adding your files / change the configuration 
as needed. Once you're really into making your project you'll notice you've 
touched most files here.

### Build and run
#### Build with python3
* `docker build -t webapp .`
* `docker run -d -p 80:80 webapp`
* go to 127.0.0.1 to see if works

#### Build with python2
* `docker build -f Dockerfile-py2 -t webapp .`
* `docker run -d -p 80:80 webapp`
* go to 127.0.0.1 to see if works

### How to insert your application

In /app currently a django project is created with startproject. You will
probably want to replace the content of /app with the root of your django
project. Then also remove the line of django-app startproject from the 
Dockerfile

uWSGI chdirs to /app so in uwsgi.ini you will need to make sure the python path
to the wsgi.py file is relative to that.
