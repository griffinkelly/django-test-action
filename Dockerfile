FROM python:2.7-jessie

RUN pip install --upgrade pip virtualenv

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    dos2unix \
    libgeos-dev \
    tcl8.5 && \
    apt-get clean && rm /var/lib/apt/lists/*_*

RUN apt-get update && apt-get dist-upgrade -y

ENV MYSQL_PWD test
RUN echo "mysql-server mysql-server/root_password password $MYSQL_PWD" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password $MYSQL_PWD" | debconf-set-selections

RUN apt-get install -y mysql-server
RUN apt install wget curl && apt-get clean

EXPOSE 3306

RUN pip install mysql-connector-python


# Environment variables
ENV DB_USER='root'
ENV DB_PASSWORD='test'
ENV DB_NAME='test'
ENV DB_HOST='127.0.0.1'
ENV DB_PORT='3306'
ENV GITHUB_TEST True


COPY ./scripts /

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]