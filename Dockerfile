FROM wnameless/mysql-phpmyadmin

MAINTAINER Erick Wasambo <erickwasambo@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

# Install MySQL
RUN apt-get install -y mysql-server mysql-client libmysqlclient-dev
# Install Apache
RUN apt-get install -y apache2
# Install php
RUN apt-get install -y php5 libapache2-mod-php5 php5-mcrypt

# Install expect
RUN apt-get install -y expect

# Install phpMyAdmin
RUN echo '#!/usr/bin/expect -f' > install-phpmyadmin.sh; \
    echo "set timeout -1" >> install-phpmyadmin.sh; \
    echo "spawn apt-get install -y phpmyadmin" >> install-phpmyadmin.sh; \
    echo "expect \"Configure database for phpmyadmin with dbconfig-common?\"" >> install-phpmyadmin.sh; \
    echo "send \"y\r\"" >> install-phpmyadmin.sh; \
    echo "expect \"Password of the database's administrative user:\"" >> install-phpmyadmin.sh; \
    echo "send \"vagrant\r\"" >> install-phpmyadmin.sh; \
    echo "expect \"MySQL application password for phpmyadmin:\"" >> install-phpmyadmin.sh; \
    echo "send \"vagrant\r\"" >> install-phpmyadmin.sh; \
    echo "expect \"Web server to reconfigure automatically:\"" >> install-phpmyadmin.sh; \
    echo "send \"1\r\"" >> install-phpmyadmin.sh
RUN chmod +x install-phpmyadmin.sh

RUN mysqld & \
    service apache2 start; \
    sleep 5; \
    ./install-phpmyadmin.sh; \
    sleep 10; \
    mysqladmin -u root shutdown

RUN rm install-phpmyadmin.sh

RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

RUN echo "Updating mysql configs in /etc/mysql/my.cnf."
RUN sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

RUN  /etc/init.d/mysql stop
RUN  /etc/init.d/mysql start


RUN sed -i "s#// \$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE;#\$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE;#g" /etc/phpmyadmin/config.inc.php 

EXPOSE 80
EXPOSE 3306

CMD service apache2 start; \
    mysqld_safe

