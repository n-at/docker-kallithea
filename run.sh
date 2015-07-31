#!/bin/bash

KALLITHEA_ADMIN_USER=${KALLITHEA_ADMIN_USER:-"admin"}
KALLITHEA_ADMIN_PASS=${KALLITHEA_ADMIN_PASS:-"admin"}
KALLITHEA_ADMIN_MAIL=${KALLITHEA_ADMIN_MAIL:-"admin@example.com"}

cd /kallithea/config

if [ ! -e kallithea.ini ]; then
    echo "Creating configuration file..."
    paster make-config Kallithea kallithea.ini

    #external database
    if [ -n "$KALLITHEA_EXTERNAL_DB" ]; then
        echo "Setting db connection string..."
        DB_ESC=$(echo "$KALLITHEA_EXTERNAL_DB" | sed -e 's/[\/&]/\\&/g')
        sed -i "s/^sqlalchemy\.db1\.url = .*/sqlalchemy.db1.url = ${DB_ESC}/1" kallithea.ini
    fi

    echo "Creating database..."
    paster setup-db kallithea.ini \
        --user=${KALLITHEA_ADMIN_USER} \
        --password=${KALLITHEA_ADMIN_PASS} \
        --email=${KALLITHEA_ADMIN_MAIL} \
        --repos=/kallithea/repos \
        --force-yes

    #rc prefix
    if [ -n "$KALLITHEA_PREFIX" ]; then
        echo "Changing rc prefix to ${KALLITHEA_PREFIX}"
        sed -i "s/#filter-with/filter-with/1" kallithea.ini
        echo "[filter:proxy-prefix]" >> kallithea.ini
        echo "use = egg:PasteDeploy#prefix" >> kallithea.ini
        echo "prefix = ${KALLITHEA_PREFIX}" >> kallithea.ini
    fi

    #ui language
    if [ -n "$KALLITHEA_LANG" ]; then
        echo "Setting language to ${KALLITHEA_LANG}"
        sed -i "s/^lang =/lang = ${KALLITHEA_LANG}/1" kallithea.ini
    fi
fi

paster serve --log-file=/kallithea/logs/paster.log kallithea.ini &
nginx -g "daemon off;"
