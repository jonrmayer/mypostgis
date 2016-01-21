FROM pgbase
MAINTAINER Jonathan Mayer <jonathan.mayer@ecountability.co.uk>

# Let the container know that there is no TTY
ENV DEBIAN_FRONTEND noninteractive

RUN git clone https://github.com/pramsey/pgsql-http.git \
&& cd pgsql-http \
&& make \
&& make install \
&& ldconfig



