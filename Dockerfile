# Используем за основу контейнера debian
FROM debian:jessie 
#FROM debootstrap/jessie
MAINTAINER Agic <agic@list.ru> 

# update
RUN apt-get update 
RUN apt-get upgrade -y 

#utils 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget curl mc apt-utils build-essential linux-headers-`uname -r` openssh-server apache2 mysql-server mysql-client bison flex php5 php5-curl php5-cli php5-mysql php-pear php5-gd curl sox libncurses5-dev libssl-dev libmysqlclient-dev mpg123 libxml2-dev libnewt-dev sqlite3 libsqlite3-dev pkg-config automake libtool autoconf git unixodbc-dev uuid uuid-dev libasound2-dev libogg-dev libvorbis-dev libcurl4-openssl-dev libical-dev libneon27-dev libsrtp0-dev libspandsp-dev sudo libmyodbc subversion vim mc autotools-dev libtool-bin python-pyrex make texi2html texinfo

#pear
RUN pear install Console_Getopt

#iksmell
WORKDIR /tmp
RUN mkdir src && cd src \
	&& git clone https://github.com/meduketto/iksemel.git \
	&& ./autogen.sh \
	&& make \
	&& make install \
	&& ldconfig

#RUN cd /usr/src && git clone https://github.com/meduketto/iksemel.git
#RUN cd /usr/src/iksemel && ./autogen.sh
#RUN cd /usr/src/iksemel && ./configure
#RUN cd /usr/src/iksemel && make
#RUN cd /usr/src/iksemel && make install 
#RUN cd /usr/src/iksemel && ldconfig

#get 

#RUN cd /usr/src && wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz && wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-current.tar.gz && wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz && wget -O jansson.tar.gz https://github.com/akheron/jansson/archive/v2.7.tar.gz && wget http://www.pjsip.org/release/2.4/pjproject-2.4.tar.bz2

#dahdi
#RUN apt-get install -y bash
#RUN cd /usr/src && tar xvfz dahdi-linux-complete-current.tar.gz 
#RUN cd /usr/src/dahdi-linux-complete-2.11.1+2.11.1 && make all
#RUN cd /usr/src/dahdi-linux-complete-2.11.1+2.11.1 && make install
#RUN cd /usr/src/dahdi-linux-complete-2.11.1+2.11.1 && make config

#libpri
#RUN cd /usr/src && tar xvfz libpri-current.tar.gz
#RUN cd /usr/src/libpri-1.5.0/ && make && make install

#pjsip
#RUN cd /usr/src && tar -xjvf pjproject-2.4.tar.bz2
#RUN cd /usr/src/pjproject-2.4 && ./configure --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr 
#RUN cd /usr/src/pjproject-2.4 && make dep
#RUN cd /usr/src/pjproject-2.4 && make
#RUN cd /usr/src/pjproject-2.4 && make install

#asterisk 
#RUN cd /usr/src && tar xvfz asterisk-13-current.tar.gz
#RUN cd /usr/src/asterisk-13.13.0 && contrib/scripts/get_mp3_source.sh
#RUN cd /usr/src/asterisk-13.13.0 && contrib/scripts/install_prereq install

# Добавляем конфиг supervisor (описание процессов, которые мы хотим видеть запущенными на этом контейнере)
#DD supervisord.conf /etc/supervisor/conf.d/supervisord.conf 

# Объявляем, какие директории мы будем подключать
#VOLUME ["/var/www"] 
# Запускаем supervisor
#CMD ["/usr/bin/supervisord"] 
