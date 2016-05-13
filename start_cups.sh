#!/bin/sh
set -e
set -x

if [ $(grep -ci $CUPS_USER_ADMIN /etc/shadow) -eq 0 ]; then
    useradd $CUPS_USER_ADMIN --system -G root,lpadmin --no-create-home --password $(mkpasswd $CUPS_USER_PASSWORD)
fi

# Add the S3 mount point
s3fs $AWSBUCKET /var/spool/cups-pdf/REVEAL -o uid=65534 -o gid=65534 -o allow_other

# start CUPS
exec /usr/sbin/cupsd -f
