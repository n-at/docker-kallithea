#!/bin/bash

KALLITHEA_ADMIN_USER=${KALLITHEA_ADMIN_USER:-"admin"}
KALLITHEA_ADMIN_PASS=${KALLITHEA_ADMIN_PASS:-"admin"}
KALLITHEA_ADMIN_MAIL=${KALLITHEA_ADMIN_MAIL:-"admin@example.com"}

cd /kallithea/config

if [ ! -e kallithea.ini ]; then
    echo "Creating configuration file..."
    paster make-config Kallithea kallithea.ini
fi

if [ ! -e kallithea.db ]; then
    echo "Creating database..."
    paster setup-db kallithea.ini \
        --user=${KALLITHEA_ADMIN_USER} \
        --password=${KALLITHEA_ADMIN_PASS} \
        --email=${KALLITHEA_ADMIN_MAIL} \
        --repos=/kallithea/repos \
        --force-yes
fi

paster serve --log-file=/kallithea/logs/paster.log kallithea.ini &
nginx -g "daemon off;"
