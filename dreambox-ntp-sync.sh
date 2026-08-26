#!/bin/bash
##command=wget -qO - https://github.com/emilnabil/dreambox/raw/refs/heads/main/dreambox-ntp-sync.sh | /bin/sh

######################
if command -v opkg &> /dev/null; then
    wget -O /tmp/dreambox-ntp-sync_all.ipk https://github.com/emilnabil/dreambox/raw/refs/heads/main/dreambox-ntp-sync_all.ipk
    opkg install /tmp/dreambox-ntp-sync_all.ipk
else
    wget -O /tmp/dreambox-ntp-sync_all.deb https://github.com/emilnabil/dreambox/raw/refs/heads/main/dreambox-ntp-sync_all.deb
    dpkg -i /tmp/dreambox-ntp-sync_all.deb
    sleep 2
    apt-get -f -y install
fi

sleep 2
reboot
exit 0
