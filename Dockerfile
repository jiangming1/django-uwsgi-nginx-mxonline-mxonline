# Copyright 2013 Thatcher Peskens
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:16.04

LABEL maintainer="w8833531 at hotmail.com"

# ENV setting 
ENV LANG=C.UTF-8  TZ=Asia/Shanghai

# TZ setting
RUN apt-get -y install tzdata && \
	ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install required packages and remove the apt packages cache when done.
RUN mv /etc/apt/sources.list /etc/apt/sources.list.org
COPY sources.list /etc/apt/
RUN apt-get update && \
    apt-get upgrade -y && \ 	
    apt-get install -y \
	git \
	nginx \
	supervisor \
    libmysqlclient-dev \
    vim \
	inetutils-ping\
	net-tools\
    libssl-dev \
	software-properties-common \
	sqlite3 && \
	tzdata && \
	rm -rf /var/lib/apt/lists/*

	 
# TZ setting
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone    


# setup all the configfiles
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx-app.conf /etc/nginx/sites-available/default
COPY supervisor-app.conf /etc/supervisor/conf.d/

# COPY requirements.txt and RUN pip install BEFORE adding the rest of your code, this will cause Docker's caching mechanism
# to prevent re-installing (all your) dependencies when you made a change a line or two in your app.
# add (the rest of) our code
COPY . /home/docker/code/

# install python3.6 and django and uwsgi 
RUN add-apt-repository -y ppa:jonathonf/python-3.6 && \
	apt-get update && \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get install -y python3.6 python3.6-dev python3-pip
RUN python3.6 -m pip install --trusted-host mirrors.aliyun.com -i http://mirrors.aliyun.com/pypi/simple --upgrade pip && \ 
	export LANG=C.UTF-8; python3.6 -m pip install --trusted-host mirrors.aliyun.com -i http://mirrors.aliyun.com/pypi/simple -r /home/docker/code/requirements.txt

# install DjangoUeditor
RUN cd /tmp && \
	git clone https://github.com/twz915/DjangoUeditor3 && \
	cd DjangoUeditor3 && \
	python3.6 setup.py install && \
	rm -rf /tmp/DjangoUeditor3


# install django, normally you would remove this step because your project would already
# be installed in the code/app/ directory
# RUN django-admin.py startproject website /home/docker/code/app/

EXPOSE 80
CMD ["supervisord", "-n"]
