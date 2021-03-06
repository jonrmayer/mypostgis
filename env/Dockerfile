FROM ubuntu:14.04
MAINTAINER Jonathan Mayer <jonathan.mayer@ecountability.co.uk>

# Let the container know that there is no TTY
ENV DEBIAN_FRONTEND noninteractive

ENV HOME /root



RUN apt-get update && apt-get install -y wget ca-certificates

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main 9.5" > /etc/apt/sources.list.d/pgdg.list && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -


RUN apt-get -y update && apt-get install -y \
    build-essential \
    cmake \
    curl \
    git \
    postgresql-9.5 \
    postgresql-server-dev-9.5 \
    libgeos-c1 \ 
    libgdal-dev \ 
    libproj-dev \ 
    libjson0-dev \ 
    libxml2-dev \ 
    libxml2-utils \ 
    xsltproc \
    docbook-xsl \
    docbook-mathml
    
RUN wget http://postgis.net/stuff/postgis-2.3.0dev.tar.gz \
&& tar xfz postgis-2.3.0dev.tar.gz \
&& cd postgis-2.3.0dev \
&& make \
&& make install \
&& ldconfig \
&& make comments-install

RUN git clone https://github.com/pramsey/pgsql-http.git \
&& cd pgsql-http \
&& make \
&& make install \
&& ldconfig

#RUN mkdir /etc/service/postgresql


# Adjust PostgreSQL configuration so that remote connections to the
# database are possible. 
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.5/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.5/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.5/main/postgresql.conf

RUN echo "http.timeout_msec = 200000" >> /etc/postgresql/9.5/main/postgresql.conf

# Expose PostgreSQL
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/data", "/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# add database setup upon image start
ADD pgpass /root/.pgpass

RUN mkdir -p /etc/my_init.d
ADD init_db_script.sh /root/init_db_script.sh
ADD init_db.sh /root/init_db.sh
ADD postgresql.sh /root/postgresql.sh 
RUN chmod 700 /root/*

ENTRYPOINT ["/root/postgresql.sh"]

CMD ["/root/init_db.sh"]



