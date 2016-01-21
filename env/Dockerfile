FROM pgbase
MAINTAINER Jonathan Mayer <jonathan.mayer@ecountability.co.uk>

# Let the container know that there is no TTY
ENV DEBIAN_FRONTEND noninteractive

ENV HOME /root

RUN git clone https://github.com/pramsey/pgsql-http.git \
&& cd pgsql-http \
&& make \
&& make install \
&& ldconfig

RUN mkdir /etc/service/postgresql
ADD postgresql.sh /etc/service/postgresql/run

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible. 
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.5/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.5/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.5/main/postgresql.conf

# Expose PostgreSQL
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/data", "/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# add database setup upon image start
ADD pgpass /root/.pgpass
RUN chmod 700 /root/.pgpass
RUN mkdir -p /etc/my_init.d
ADD init_db_script.sh /etc/my_init.d/init_db_script.sh
ADD init_db.sh /root/init_db.sh

# ---------- Final cleanup --------------
#
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



