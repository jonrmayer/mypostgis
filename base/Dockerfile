FROM ubuntu:14.04
MAINTAINER Jonathan Mayer <jonathan.mayer@ecountability.co.uk>

# Let the container know that there is no TTY
ENV DEBIAN_FRONTEND noninteractive

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
    

 
# Cleanup --------------------------------

RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Publish --------------------------------


