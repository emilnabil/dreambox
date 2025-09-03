wget -O /tmp/tsmedia.deb https://github.com/emilnabil/dreambox/raw/refs/heads/main/tsmedia.deb
dpkg -i /tmp/tsmedia.deb
sleep 2
apt-get -f -y install


