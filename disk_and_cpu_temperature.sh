#!/bin/sh

# wget -q --no-check-certificate https://raw.githubusercontent.com/emilnabil/dreambox/refs/heads/main/disk_and_cpu_temperature.sh -O - | /bin/sh

TEMPATH="/tmp"
MY_IPK="enigma2-plugin-extensions-Disk_and_CPU_Temperature_all.ipk"
MY_DEB="enigma2-plugin-extensions-Disk_and_CPU_Temperature_all.deb"
MY_URL="https://raw.githubusercontent.com/emilnabil/dreambox/refs/heads/main"

echo ">>>> Removing old version if exists <<<<"

if which dpkg > /dev/null 2>&1; then
    apt-get purge --auto-remove -y enigma2-plugin-extensions-Disk_and_CPU_Temperature >/dev/null 2>&1
    dpkg --purge --force-all enigma2-plugin-extensions-Disk_and_CPU_Temperature >/dev/null 2>&1
    dpkg --remove --force-depends enigma2-plugin-extensions-Disk_and_CPU_Temperature >/dev/null 2>&1
else
    opkg remove enigma2-plugin-extensions-Disk_and_CPU_Temperature --force-depends >/dev/null 2>&1
fi

rm -rf /usr/lib/enigma2/python/Plugins/SystemPlugins/DiskCpuTemp >/dev/null 2>&1

echo ""
echo ">>>> Starting installation <<<<"
cd /tmp

if which dpkg > /dev/null 2>&1; then
    apt-get update >/dev/null 2>&1
    apt-get install -y smartmontools >/dev/null 2>&1
    wget -q "$MY_URL/$MY_DEB"
    sleep 2
    dpkg -i --force-overwrite "$MY_DEB" >/dev/null 2>&1
    apt-get install -f -y >/dev/null 2>&1
    rm -f /tmp/*.deb >/dev/null 2>&1
else
    opkg update >/dev/null 2>&1
    opkg install smartmontools >/dev/null 2>&1
    wget -q "$MY_URL/$MY_IPK"
    sleep 2
    opkg install --force-reinstall "$MY_IPK" >/dev/null 2>&1
    rm -f /tmp/*.ipk >/dev/null 2>&1
fi

INSTALL_STATUS=$?
cd ..

if [ "$INSTALL_STATUS" -eq 0 ]; then
    echo ">>>>  SUCCESSFULLY INSTALLED <<<<"
else
    echo ">>>>  INSTALLATION FAILED <<<<"
    echo ">>>>  Please check the error messages above <<<<"
    exit 1
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


