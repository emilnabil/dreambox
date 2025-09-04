wget -O /tmp/gutemine_4.2-r9_armhf.deb https://github.com/emilnabil/dreambox/raw/refs/heads/main/gutemine_4.2-r9_armhf.deb
dpkg -i /tmp/gutemine_4.2-r9_armhf.deb
sleep 2
apt-get -f -y install



