#!/bin/bash

apt-get update
apt-get autoremove -y geminilocale
sleep 2 
rm -rf /usr/lib/enigma2/python/Plugins/GP4/geminilocale

exit
