FROM debian:bookworm

ARG USER_ID=1000
ARG GROUP_ID=1000

MAINTAINER Fer Uria <fauria@gmail.com>
LABEL Description="vsftpd Docker image based on Debian 12. Supports passive mode and virtual users." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST PORT NUMBER]:21 -v [HOST FTP HOME]:/home/vsftpd fauria/vsftpd" \
	Version="1.0"

RUN apt update
RUN apt install -y vsftpd db-util iproute2

RUN cat /etc/vsftpd.conf

RUN usermod -u ${USER_ID} ftp
RUN groupmod -g ${GROUP_ID} ftp

ENV FTP_USER **String**
ENV FTP_PASS **Random**
ENV PASV_ADDRESS **IPv4**
ENV PASV_ADDR_RESOLVE NO
ENV PASV_ENABLE YES
ENV PASV_MIN_PORT 21100
ENV PASV_MAX_PORT 21110
ENV XFERLOG_STD_FORMAT NO
ENV LOG_STDOUT **Boolean**
ENV FILE_OPEN_MODE 0666
ENV LOCAL_UMASK 077
ENV REVERSE_LOOKUP_ENABLE YES
ENV PASV_PROMISCUOUS NO
ENV PORT_PROMISCUOUS NO
ENV SSL_ENABLE NO
ENV TLS_CERT cert.pem
ENV TLS_KEY key.pem

COPY vsftpd.conf /etc/vsftpd/
COPY vsftpd_virtual /etc/pam.d/
COPY run-vsftpd.sh /usr/sbin/

RUN chmod +x /usr/sbin/run-vsftpd.sh
RUN mkdir -p /home/vsftpd/
RUN chown -R ftp:ftp /home/vsftpd/

RUN mkdir -p /var/run/vsftpd/empty
RUN chown root:root /var/run/vsftpd/empty

VOLUME /home/vsftpd
VOLUME /var/log/vsftpd
VOLUME /etc/vsftpd/cert

EXPOSE 20 21

CMD ["/usr/sbin/run-vsftpd.sh"]
