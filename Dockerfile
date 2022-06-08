FROM mysql:8.0.29


RUN apt update
RUN apt install -y python2

RUN apt-get update && apt-get dist-upgrade -y
RUN apt install -y curl
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
RUN python2 get-pip.py



RUN pip install mysql-connector-python


# Environment variables
ENV DB_USER='root'
ENV DB_PASSWORD='test'
ENV DB_NAME='test'
ENV DB_HOST='127.0.0.1'
ENV DB_PORT='3306'
ENV GITHUB_TEST True

# Create DB and User
USER mysql
CMD service mysqld start 
CMD mysql -c "CREATE USER ${DB_USER} WITH SUPERUSER PASSWORD '${DB_PASSWORD}';ALTER USER ${DB_USER} CREATEDB;" \
&& mysql -c "CREATE DATABASE ${DB_NAME} WITH owner ${DB_USER}"
USER root

COPY ./scripts /

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]