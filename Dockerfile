FROM python:2.7-buster

RUN pip install --upgrade pip virtualenv

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    dos2unix \
    libgeos-dev \
    tcl8.6 && \
    apt-get clean && rm /var/lib/apt/lists/*_*

RUN apt-get update && apt-get dist-upgrade -y

ENV MYSQL_PWD test
RUN echo "mysql-server mysql-server/root_password password $MYSQL_PWD" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password $MYSQL_PWD" | debconf-set-selections

RUN apt install gnupg
ARG MYSQL_APT_DEB=mysql-apt-config_0.8.22-1_all.deb
RUN wget https://dev.mysql.com/get/${MYSQL_APT_DEB}
RUN echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.7" | debconf-set-selections && \
  DEBIAN_FRONTEND=noninteractive apt install ./${MYSQL_APT_DEB} -y

# mysql-client does not exist for M1 Macs / arm64, so force debian to install an amd64 version
RUN DPKG_ARCH=$(dpkg --print-architecture ) && if [ $DPKG_ARCH = arm64 ]; then dpkg --add-architecture amd64; fi

RUN apt-get update && \
  apt-get install -y mysql-community-client mysql-client


RUN apt install wget curl && apt-get clean

RUN pip install mysql-connector-python

# Environment variables
ENV DB_USER='test'
ENV DB_PASSWORD='password'
ENV DB_NAME='test'
ENV DB_HOST='127.0.0.1'
ENV DB_PORT='5432'
ENV GITHUB_TEST True

# CMD /bin/bash 
# # Create DB and User
# # USER mysql
# CMD service mysql start && mysql -e "CREATE DATABASE ${DB_NAME}"
# # && mysql -c "CREATE USER ${DB_USER} WITH SUPERUSER PASSWORD '${DB_PASSWORD}';ALTER USER ${DB_USER} CREATEDB;" \
# # && mysql -c "CREATE DATABASE ${DB_NAME} WITH owner ${DB_USER}"
# # USER root
COPY ./scripts /

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
