FROM debian:jessie
MAINTAINER Matt OConnell <moconnell@66feet.com>

# Install cups - poppler-utils allow for PDF processing
RUN apt-get update && apt-get install -y \
    cups \
    cups-pdf \
    whois \
    poppler-utils

# Build and install S3FS
RUN apt-get install -y build-essential \
    git \
    libfuse-dev \
    libcurl4-openssl-dev \
    libxml2-dev mime-support \
    automake \
    libtool

RUN apt-get install -y pkg-config \
    libssl-dev

RUN cd /usr/src && git clone https://github.com/s3fs-fuse/s3fs-fuse
RUN cd /usr/src/s3fs-fuse/ && ./autogen.sh && ./configure --prefix=/usr --with-openssl && make && make install

# Build and install node & PDF util
RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl python build-essential git ca-certificates
RUN mkdir /nodejs && curl http://nodejs.org/dist/v4.4.4/node-v4.4.4-linux-x64.tar.xz | tar xJf - -C /nodejs --strip-components=1

ENV PATH $PATH:/nodejs/bin

RUN npm install -g pdf-to-text

# Some clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up podbot
ADD podbot /usr/local/podbot
RUN chmod +x /usr/local/podbot/node_cmd.sh

# Set up CUPS
ADD etc-cups /etc/cups
VOLUME /etc/cups/
VOLUME /var/log/cups
VOLUME /var/spool/cups
VOLUME /var/cache/cups

# add dir where s3 mount will go
RUN mkdir /var/spool/cups-pdf/REVEAL
RUN chown nobody:nogroup /var/spool/cups-pdf/REVEAL

EXPOSE 631

ADD start_cups.sh /root/start_cups.sh
RUN chmod +x /root/start_cups.sh
CMD ["/root/start_cups.sh"]
