FROM ubuntu:14.04

MAINTAINER Alexey Nurgaliev <atnurgaliev@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y python python-pip python-ldap mercurial git wget \
                       python-dev software-properties-common libmysqlclient-dev libpq-dev && \
    add-apt-repository -y ppa:nginx/stable && \
    apt-get update && \
    apt-get install -y nginx && \
    \
    mkdir /kallithea && \
    cd /kallithea && \
    mkdir -m 0777 config repos logs kallithea && \
    wget https://pypi.io/packages/72/b3/a135896270360385ae5b47a5a7d119e90143334e30d93fb68c26ec59edfc/Kallithea-0.3.2.tar.gz && \
    tar -xf Kallithea-0.3.2.tar.gz -C kallithea --strip-components 1 && \
    cd kallithea && \
    python -m pip install --upgrade --force pip && \
    pip install -e . && \
    python setup.py compile_catalog && \
    \
    pip install mysql-python && \
    pip install psycopg2 && \
    \
    apt-get purge --auto-remove -y python-dev software-properties-common wget && \
    \
    rm /etc/nginx/sites-enabled/*

ADD kallithea_vhost /etc/nginx/sites-enabled/kallithea_vhost
ADD run.sh /kallithea/run.sh

VOLUME ["/kallithea/config", "/kallithea/repos", "/kallithea/logs"]

EXPOSE 80

CMD ["/kallithea/run.sh"]
