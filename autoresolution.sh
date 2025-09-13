#!/bin/bash
# command=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/autoresolution.sh -O - | /bin/sh
###################

wget -q --no-check-certificate -O /tmp/autoresolution.deb https://github.com/emilnabil/dreambox/raw/refs/heads/main/autoresolution.deb

dpkg -i /tmp/autoresolution.deb

apt-get -f -y install

exit 0


