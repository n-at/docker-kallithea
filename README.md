Docker Kallithea
================

Image contains [kallithea](https://kallithea-scm.org/) source code management system.

Usage
-----

Run a container with:

    $ docker run -d -p 8085:80 atnurgaliev/kallithea

You can specify some environment variables:

* `KALLITHEA_ADMIN_USER` - administrator login (default: `admin`)
* `KALLITHEA_ADMIN_PASS` - administrator password (default: `admin`)
* `KALLITHEA_ADMIN_MAIL` - administrator e-mail (default: `admin@example.com`)

Available volumes:

* `/kallithea/config` - contains configuration file (`kallithea.ini`) and SQLite database 
  (`kallithea.db`).
* `/kallithea/repos` - contains repositories.
* `/kallithea/logs` - contains log files.

Example of container with mounted volumes and new admin password running on port 8085:
 
    $ docker run -d -p 8085:80 \
        -e KALLITHEA_ADMIN_PASS=secret \
        -v /opt/kallithea/config:/kallithea/config \
        -v /opt/kallithea/repos:/kallithea/repos \
        atnurgaliev/kallithea
