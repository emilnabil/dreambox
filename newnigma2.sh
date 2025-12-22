#!/bin/bash

#configuration
#########################################
BOXNAME=$(head -n 1 /etc/hostname)
image='newnigma2'
version='image'
today=$(date +%d-%m-%Y)

#detetmine image name
#########################################
case "$BOXNAME" in
dm900)
echo "> Device detected: ARM - DM900"
sleep 3
IMAGE_NAME="newnigma2-deb-weekly-OE2.5-dm900-09_06_2024.tar.xz"
DOWNLOAD_URL="https://feed.newnigma2.to/daily/images/$IMAGE_NAME"
;;
dm920)
echo "> Device detected: ARM - DM920"
sleep 3
IMAGE_NAME="newnigma2-deb-weekly-OE2.5-dm920-09_06_2024.tar.xz"
DOWNLOAD_URL="https://feed.newnigma2.to/daily/images/$IMAGE_NAME"
;;
dreamone)
echo "> Device detected: Dream One"
sleep 3
IMAGE_NAME="newnigma2-deb-weekly-OE2.6-dreamone-09_06_2024.tar.xz"
DOWNLOAD_URL="https://feed.newnigma2.to/daily/images/$IMAGE_NAME"
;;
dreamtwo)
echo "> Device detected: Dream Two"
sleep 3
IMAGE_NAME="newnigma2-deb-weekly-OE2.6-dreamtwo-09_06_2024.tar.xz"
DOWNLOAD_URL="https://feed.newnigma2.to/daily/images/$IMAGE_NAME"
;;
dm520)
echo "> Device detected: DM520"
sleep 3
IMAGE_NAME="newnigma2-deb-weekly-OE2.5-dm520-09_06_2024.tar.xz"
DOWNLOAD_URL="https://feed.newnigma2.to/daily/images/$IMAGE_NAME"
;;
dm820)
echo "> Device detected: DM820"
sleep 3
IMAGE_NAME="newnigma2-deb-weekly-OE2.5-dm820-09_06_2024.tar.xz"
DOWNLOAD_URL="https://feed.newnigma2.to/daily/images/$IMAGE_NAME"
;;
dm7080)
echo "> Device detected: DM7080"
sleep 3
IMAGE_NAME="newnigma2-deb-weekly-OE2.5-dm7080-09_06_2024.tar.xz"
DOWNLOAD_URL="https://feed.newnigma2.to/daily/images/$IMAGE_NAME"
;;
*)
echo "> your device is not supported"
exit 1
;;
esac

echo "> "$IMAGE_NAME" image found ..."
sleep 5

#check mounted storage
#########################################
ms=""
for ms in "/media/hdd" "/media/usb" "/media/mmc" "/media/ba"
do
    if mount|grep $ms >/dev/null 2>&1; then
    echo "> Mounted storage found at: $ms"
    mkdir "$ms"/images >/dev/null 2>&1
    break
    fi
done

if [ -z "$ms" ]; then
echo "> Mount your external memory and try again"
exit 1
fi
sleep 3

#download image to mounted storage
#########################################
echo "> Downloading "$image"-"$version" image to "$ms"/images please wait..."
sleep 3

if wget -q --method=HEAD "$DOWNLOAD_URL";
 then
wget --show-progress -qO $ms/images/$IMAGE_NAME "$DOWNLOAD_URL"
else
echo "> check your internet connection and try again or your device is not supported..."
exit 1
fi

echo "> Download of "$image"-"$version" image to "$ms"/images is finished"
sleep 3

#copy image to multiboot upload folders
#########################################
for dir in "/media/hdd/backup/" "/media/usb/backup/" "/media/mmc/backup/" "/media/ba/backup/"
do
if [ -d $dir ] ; then
echo "> "$dir" folder found ..."
sleep 1
echo "> copying image to "$dir" folder please wait ..."
sleep 1
cp $ms/images/$IMAGE_NAME $dir >/dev/null 2>&1
fi
done

echo "> Process completed successfully!"
exit



