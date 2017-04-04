FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apache2 \
    unzip \
    ssh \
    php \
    python \
    git \
    curl \
    sudo \
    libapache2-mod-php \
    libcurl3 \
    libhiredis0.13 \
    libjansson4 \
    gettext-base \
    curl \
 && rm -rf /var/lib/apt/lists/*

# Install OpenID mod (this version is newer than then one in the official apt repos)
WORKDIR /tmp
RUN wget https://github.com/pingidentity/mod_auth_openidc/releases/download/v2.1.3/libcjose_0.4.1-1ubuntu1.wily.1_amd64.deb
RUN wget https://github.com/pingidentity/mod_auth_openidc/releases/download/v2.1.6/libapache2-mod-auth-openidc_2.1.6-1ubuntu1.wily.1_amd64.deb
RUN dpkg -i lib*.deb

# Deploying a phpinfo page (useful for testing and reviewing headers and env variables)
RUN mkdir -p /var/www/html/phpinfo/
COPY repo/index.php /var/www/html/phpinfo/

# Setting up HTTP and HTTPs
COPY repo/https_*.conf /etc/apache2/sites-available/
COPY repo/000-default.conf /etc/apache2/sites-available/

# hardening + certificates installation
COPY repo/ssl_hardening.conf /etc/apache2/
COPY repo/ssl_stapling_cache.conf /etc/apache2/conf-enabled/

# install your ssl certs here
COPY secrets/WildcardPrivate.key /etc/ssl/private
COPY secrets/WildcardCert.crt /etc/ssl/certs

RUN a2ensite 000-default
RUN a2enmod proxy_http auth_basic env setenvif ssl rewrite php7.0 auth_openidc rewrite headers

COPY repo/run.sh /

EXPOSE 80
EXPOSE 443

CMD /run.sh
