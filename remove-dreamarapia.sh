#!/bin/bash
#
##Command=wget https://raw.githubusercontent.com/emilnabil/dreambox/refs/heads/main/remove-dreamarapia.sh -O - | /bin/sh
####################

apt-get update && apt-get autoremove -y dreamarabia-addons-feed
sleep 2 
rm /etc/enigma2/AddonFilterlist_dreamarabia.json
rm /etc/enigma2/AddonFilterlistuser.json​







