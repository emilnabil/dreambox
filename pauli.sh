#!/bin/bash
# command=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/pauli.sh -O - | /bin/sh

apt update
wget -O /tmp/enigma2-plugin-extensions-pauli_8.0-r2_all.deb https://github.com/emilnabil/dreambox/raw/refs/heads/main/enigma2-plugin-extensions-pauli_8.0-r2_all.deb
dpkg -i /tmp/enigma2-plugin-extensions-pauli_8.0-r2_all.deb
apt install -f -y
sleep 2
rm -f/tmp/enigma2-plugin-extensions-pauli_8.0-r2_all.deb
exit 0


