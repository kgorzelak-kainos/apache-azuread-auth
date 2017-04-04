#!/bin/bash
# The following lines will replace all the variables defined in apache config files with the real environment variables
# The environment variables will be resolved once (before the http server execution) and in the context of a system (not individual http request). 
# This gives us great flexibility to set them with the docker's env file.

for f in /etc/apache2/sites-available/https_*.conf
do
    envsubst < ${f} > /etc/apache2/sites-enabled/$(basename ${f});
done

exec apachectl  -f /etc/apache2/apache2.conf -e info -DFOREGROUND
