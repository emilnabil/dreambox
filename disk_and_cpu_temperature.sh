#!/bin/sh

#wget -q --no-check-certificate https://github.com/emilnabil/dreambox/raw/refs/heads/main/disk_and_cpu_temperature.sh -O - | /bin/sh

##########################################
TEMPATH=/tmp
OPKGINSTALL="opkg install --force-reinstall"
MY_IPK="enigma2-plugin-extensions-Disk_and_CPU_Temperature_all.ipk"
MY_DEB="enigma2-plugin-extensions-Disk_and_CPU_Temperature_all.deb"
MY_URL="https://github.com/emilnabil/dreambox/raw/refs/heads/main"
# remove old version #
if which dpkg > /dev/null 2>&1; then
	apt-get purge --auto-remove -y enigma2-plugin-extensions-Disk_and_CPU_Temperature &>/dev/null
	dpkg --purge --force-all enigma2-plugin-extensions-Disk_and_CPU_Temperature &>/dev/null
	dpkg --remove --force-depends enigma2-plugin-extensions-Disk_and_CPU_Temperature &>/dev/null
rm -rf /usr/lib/enigma2/python/Plugins/SystemPlugins/DiskCpuTemp
else
opkg remove enigma2-plugin-extensions-Disk_and_CPU_Temperature
rm -rf /usr/lib/enigma2/python/Plugins/SystemPlugins/DiskCpuTemp

echo ""
# Download and install plugin

cd /tmp

 if which dpkg > /dev/null 2>&1; then
wget "$MY_URL/$MY_DEB"
sleep 2 
		dpkg -i --force-overwrite $MY_DEB; apt-get install -f -y
sleep 2
rm -f /tmp/*.deb
	else
wget "$MY_URL/$MY_IPK"
sleep 2 
		$OPKGINSTALL $MY_IPK
sleep 2
rm -f /tmp/*.ipk
	fi
echo "================================="
cd ..

	if [ $? -eq 0 ]; then
echo ">>>>  SUCCESSFULLY INSTALLED <<<<"
fi
		echo "********************************************************************************"
echo "   UPLOADED BY  >>>>   EMIL_NABIL "   
sleep 4
		echo ". >>>>         RESTARING     <<<<"
echo "**********************************************************************************"
wait
killall -9 enigma2
exit 0
