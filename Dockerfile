# Используем за основу контейнера debian
FROM debian:jessie 
#FROM debootstrap/jessie
MAINTAINER Agic <agic@list.ru> 

# update
RUN apt-get update 
RUN apt-get upgrade -y 

#utils 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget curl mc apt-utils build-essential linux-headers-`uname -r` openssh-server apache2 mysql-server mysql-client bison flex php5 php5-curl php5-cli php5-mysql php-pear php5-gd curl sox libncurses5-dev libssl-dev libmysqlclient-dev mpg123 libxml2-dev libnewt-dev sqlite3 libsqlite3-dev pkg-config automake libtool autoconf git unixodbc-dev uuid uuid-dev libasound2-dev libogg-dev libvorbis-dev libcurl4-openssl-dev libical-dev libneon27-dev libsrtp0-dev libspandsp-dev sudo libmyodbc subversion vim mc autotools-dev libtool-bin python-pyrex make texi2html texinfo uuid-dev build-essential libxml2-dev libncurses5-dev libsqlite3-dev libssl-dev libxslt-dev libjansson-dev bash

#pear
RUN pear install Console_Getopt

#iksmell
WORKDIR /tmp
RUN mkdir src && cd src \
	&& git clone https://github.com/meduketto/iksemel.git \
	&& cd iksemel && ./autogen.sh \
	&& ./configure \
	&& make \
	&& make install \
	&& ldconfig


#get 
WORKDIR /tmp

RUN cd /tmp/src && wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz && wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-current.tar.gz && wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz && wget -O jansson.tar.gz https://github.com/akheron/jansson/archive/v2.7.tar.gz && wget http://www.pjsip.org/release/2.4/pjproject-2.4.tar.bz2

#dahdi
WORKDIR /tmp/src
RUN tar xvfz dahdi-linux-complete-current.tar.gz \
	&& cd /tmp/src/dahdi-linux-complete-2.11.1+2.11.1 && make all \
	&& make install \
	&& make config


#libpri
WORKDIR /tmp/src
RUN  tar xvfz libpri-current.tar.gz \
	&& cd libpri-1.5.0 && make \
	&& make install 

#pjsip
WORKDIR /tmp/src
RUN tar -xjvf pjproject-2.4.tar.bz2 \
	&& cd pjproject-2.4 && ./configure --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr \
	&& make dep \
	&& make \
	&& make install 

#asterisk 
WORKDIR /tmp/src
RUN  tar xvfz asterisk-13-current.tar.gz \
	&& cd asterisk-13.13.0 && contrib/scripts/get_mp3_source.sh \
	&& ./configure 

WORKDIR /tmp/src/asterisk-13.13.0
RUN make menuselect.makeopts
RUN menuselect/menuselect \
	--enable format_mp3 \
	--enable res_config_mysql \
	--enable app_mysql \
	--enable cdr_mysql \ 
	--enable CORE-SOUNDS-RU-WAV \
	--enable CORE-SOUNDS-RU-ULAW \ 
	--enable CORE-SOUNDS-RU-ALAW \ 
	--enable CORE-SOUNDS-RU-GSM \
	--enable CORE-SOUNDS-RU-G729 \
	--enable CORE-SOUNDS-RU-G722 \
	--enable CORE-SOUNDS-RU-SLN16 \
	--enable CORE-SOUNDS-RU-SIREN7 \
	--enable CORE-SOUNDS-RU-SIREN14 \
	--enable EXTRA-SOUNDS-EN-WAV \
	--enable EXTRA-SOUNDS-EN-ULAW \
	--enable EXTRA-SOUNDS-EN-ALAW \
	--enable EXTRA-SOUNDS-EN-GSM \
	--enable EXTRA-SOUNDS-EN-G729 \
	--enable EXTRA-SOUNDS-EN-G722 \
	--enable EXTRA-SOUNDS-EN-SLN16 \
	--enable EXTRA-SOUNDS-EN-SIREN7 \
	--enable EXTRA-SOUNDS-EN-SIREN14 \
 menuselect.makeopts
RUN make
RUn make install 
RUN make samples && make config 

#User add 

RUN useradd -m asterisk -s /sbin/nologin
RUN chown asterisk:asterisk /var/run/asterisk
RUN chown -R asterisk:asterisk /etc/asterisk/
#RUN chown -R asterisk:asterisk /var/{lib,log,spool}/asterisk
RUN chown -R asterisk:asterisk /var/lib/asterisk/
RUN chown -R asterisk:asterisk /var/log/asterisk/
RUN chown -R asterisk:asterisk /var/spool/asterisk/

# start
CMD /usr/sbin/asterisk -f -U asterisk -G asterisk -vvvg -c
