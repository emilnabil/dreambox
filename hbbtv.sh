#!/bin/bash
# command=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/hbbtv.sh -O - | /bin/sh
###################

wget -q --no-check-certificate -O /tmp/hbbtv.deb https://github.com/emilnabil/dreambox/raw/refs/heads/main/hbbtv.deb

dpkg -i /tmp/hbbtv.deb

apt-get -f -y install

exit 0



