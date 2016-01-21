FROM ubuntu:14.04
MAINTAINER Jonathan Mayer <jonathan.mayer@ecountability.co.uk>

# Let the container know that there is no TTY
ENV DEBIAN_FRONTEND noninteractive

# Install necessary packages for proper system state
RUN apt-get -y update && apt-get install -y \
    build-essential \
    cmake \
    curl \
    git \
    postgresql-9.4 \
    postgresql-server-dev-9.4 \
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
&& tar xfj geos-3.5.0.tar.bz2 \
&& make \
&& make install \
&& ldconfig \
&& make comments-install
    

 
# Cleanup --------------------------------

RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Publish --------------------------------


