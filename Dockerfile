FROM registry.zveronline.ru/docker/docker-x2go:kde

ENV TZ=Europe/Moscow
ENV NOTVISIBLE="in users profile"

ADD config /config
ADD entrypoint.sh /entrypoint.sh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
&& apt-get update && apt-get upgrade -y && apt-get install -y nano htop mc git openssh-server mysql-client postgresql-client zip tar gzip p7zip unzip perl procps wget screen openjdk-8-jdk locales dialog apt-utils x2goserver x2goserver-xsession supervisor kde-full \
&& locale-gen ru_RU.UTF-8 \
&& update-locale LANG=ru_RU.UTF-8 \
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
