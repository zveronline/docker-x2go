FROM ubuntu:20.04

ENV TZ=Europe/Moscow
ENV NOTVISIBLE="in users profile"
ENV DEBIAN_FRONTEND noninteractive
ENV USER_PASSWORD=qwe123

RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y language-pack-ru
ENV LANGUAGE ru_RU.UTF-8
ENV LANG ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8
RUN locale-gen ru_RU.UTF-8 && dpkg-reconfigure locales

ADD config /config
ADD entrypoint.sh /entrypoint.sh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
&& apt-get install -y nano htop mc git openssh-server mysql-client postgresql-client zip tar gzip p7zip unzip perl procps wget screen openjdk-8-jdk locales dialog apt-utils x2goserver x2goserver-xsession supervisor xfce4 xfce4-goodies \
&& mkdir /var/run/sshd \
&& sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
&& sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config  \
&& sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
&& echo "export VISIBLE=now" >> /etc/profile \
&& chmod 755 /entrypoint.sh \
&& chmod -R 700 /config \
&& cp /config/supervisor/sshd.conf /etc/supervisor/conf.d/sshd.conf \
&& cp /config/supervisor/x2go.conf /etc/supervisor/conf.d/x2go.conf \
&& useradd -s /bin/bash zveronline

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
ENTRYPOINT ["/entrypoint.sh"]
