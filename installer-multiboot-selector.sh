wget -O /tmp/multibootselector_1.16-r0_all.deb https://github.com/emilnabil/dreambox/raw/refs/heads/main/multibootselector_1.16-r0_all.deb
dpkg -i /tmp/multibootselector_1.16-r0_all.deb
sleep 2
apt-get -f -y install



