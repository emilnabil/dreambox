#!/bin/sh

# wget -q --no-check-certificate https://raw.githubusercontent.com/emilnabil/dreambox/refs/heads/main/disk_and_cpu_temperature.sh -O - | /bin/sh

##########################################
TEMPATH=/tmp
OPKGINSTALL="opkg install --force-reinstall"
MY_IPK="enigma2-plugin-extensions-Disk_and_CPU_Temperature_all.ipk"
MY_DEB="enigma2-plugin-extensions-Disk_and_CPU_Temperature_all.deb"
MY_URL="https://raw.githubusercontent.com/emilnabil/dreambox/refs/heads/main"

if which dpkg > /dev/null 2>&1; then
    apt-get purge --auto-remove -y enigma2-plugin-extensions-Disk_and_CPU_Temperature &>/dev/null
    dpkg --purge --force-all enigma2-plugin-extensions-Disk_and_CPU_Temperature &>/dev/null
    dpkg --remove --force-depends enigma2-plugin-extensions-Disk_and_CPU_Temperature &>/dev/null

else
    opkg remove enigma2-plugin-extensions-Disk_and_CPU_Temperature
fi
rm -rf /usr/lib/enigma2/python/Plugins/SystemPlugins/DiskCpuTemp

echo ""
echo ">>>> Starting installation <<<<"
cd /tmp

if which dpkg > /dev/null 2>&1; then
apt-get install-y smartmontools
    wget "$MY_URL/$MY_DEB"
    sleep 2 
    dpkg -i --force-overwrite $MY_DEB
    apt-get install -f -y
    rm -f /tmp/*.deb
else
opkg install smartmontools
    wget "$MY_URL/$MY_IPK"
    sleep 2 
    $OPKGINSTALL $MY_IPK
    rm -f /tmp/*.ipk
fi

cd ..

if [ $? -eq 0 ]; then
    echo ">>>>  SUCCESSFULLY INSTALLED <<<<"
else
    echo ">>>>  INSTALLATION FAILED <<<<"
fi

echo "********************************************************************************"
echo "   UPLOADED BY  >>>>   EMIL_NABIL "   
echo "********************************************************************************"
sleep 4

echo ">>>>         RESTARTING ENIGMA2     <<<<"
if which dpkg > /dev/null 2>&1; then
    systemctl restart enigma2
else
    killall -9 enigma2
fi

exit 0



