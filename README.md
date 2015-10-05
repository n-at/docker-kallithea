Docker Kallithea
================

Image contains [kallithea](https://kallithea-scm.org/) source code management system.

Available tags:

* [atnurgaliev/kallithea:latest](https://github.com/n-at/docker-kallithea/tree/master) - 
  latest version from `stable` branch
* [atnurgaliev/kallithea:0.3](https://github.com/n-at/docker-kallithea/tree/v0.3) - 
  stable 0.3 version from PyPI
* [atnurgaliev/kallithea:0.2](https://github.com/n-at/docker-kallithea/tree/v0.2) -
  stable 0.2 version from PyPI

Usage
-----

Run a container with:

    $ docker run -d -p 8085:80 atnurgaliev/kallithea

You can specify some environment variables:

* `KALLITHEA_ADMIN_USER` - administrator login (default: `admin`)
* `KALLITHEA_ADMIN_PASS` - administrator password (default: `admin`)
* `KALLITHEA_ADMIN_MAIL` - administrator e-mail (default: `admin@example.com`)

If you don't have kallithea configuration file (running first time or without mounting a configuration volume), 
you can set additional variables:

* `KALLITHEA_PREFIX` - set resources prefix 
  (empty by default, see [documentation](http://docs.kallithea-scm.org/en/latest/setup.html#apache-as-subdirectory))
* `KALLITHEA_LANG` - set language (empty by default, can be one of `cs de fr hu ja nl_BE pl pt_BR ru sk zh_CN zh_TW`)
* `KALLITHEA_EXTERNAL_DB` - connection string for external database instead of built-in SQLite (empty by default, 
   currently MySQL and PostgreSQL are supported, 
   see [sqlalchemy documentation](http://docs.sqlalchemy.org/en/rel_1_0/dialects/index.html) for examples)

Available volumes:

* `/kallithea/config` - contains configuration file (`kallithea.ini`).
* `/kallithea/repos` - contains repositories.
* `/kallithea/logs` - contains log files.

Example of container with mounted volumes and new admin password running on port 8085:
 
    $ docker run -d -p 8085:80 \
        -e KALLITHEA_ADMIN_PASS=secret \
        -v /opt/kallithea/config:/kallithea/config \
        -v /opt/kallithea/repos:/kallithea/repos \
        atnurgaliev/kallithea
