#FROM phusion/baseimage:18.04-1.0.0-amd64
FROM phusion/baseimage:focal-1.2.0
ENV WEEWX_VERSION=4.8.0
ENV HOME=/home/weewx

#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
RUN apt-get -y update

RUN apt-get install -y apt-utils

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# debian, ubuntu, mint, raspbian
# for systems that do not have python 3 installed (for example, ubuntu 18.04 and later):
RUN apt-get install -y python3 python3-pip python3-configobj python3-serial python3-mysqldb python3-usb default-mysql-client sqlite3 curl rsync ssh tzdata wget gftp syslog-ng xtide xtide-data zlib1g-dev libjpeg-dev libfreetype6-dev
RUN pip3 install Cheetah3 Pillow pyephem setuptools requests dnspython paho-mqtt configobj pyusb pyserial
RUN ln -f -s /usr/bin/python3 /usr/bin/python
RUN mkdir /var/log/weewx
RUN mkdir -p /home/weewx/src
# install weewx from source
ADD dist/weewx-$WEEWX_VERSION /home/weewx/src/
RUN cd /home/weewx/src && ./setup.py build
RUN cd /home/weewx/src && echo "tom.org simulator\n1211, foot\n44.491\n-71.689\nn\nus\n3\n" | ./setup.py install
# install plugins - NOTE, you need to do this after you build because user dir
# is mounted.  so shell in and run the commands
# you will also need to upgrade after build/run if version in weewx.conf
# doesn't match version you are installing
# /home/weewx/bin/wee_config --upgrade --dist-config /home/weewx/weewx.conf.4.8.0 /data/weewx.conf

RUN mkdir /home/weewx/tmp
RUN mkdir /home/weewx/public_html

RUN mkdir -p /etc/service/weewx

ADD bin/run /etc/service/weewx/
RUN chmod 755 /etc/service/weewx/run

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]
