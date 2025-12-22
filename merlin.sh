#!/bin/bash
#command=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/merlin.sh -O - | /bin/sh
####################
#configuration
#########################################
BOXNAME=$(head -n 1 /etc/hostname)
image='merlin'
version='image'
today=$(date +%d-%m-%Y)

#detetmine image name
#########################################
case "$BOXNAME" in
dm900)
echo "> Device detected: ARM - DM900"
sleep 3
IMAGE_NAME="Merlin_OE-2.5-dm900-experimental-20241130.tar.xz"
DOWNLOAD_URL="https://merlinfeed.boxpirates.to/images_oe_2.5/$IMAGE_NAME"
;;
dm920)
echo "> Device detected: ARM - DM920"
sleep 3
IMAGE_NAME="Merlin_OE-2.5-dm920-experimental-20241130.tar.xz"
DOWNLOAD_URL="https://merlinfeed.boxpirates.to/images_oe_2.5/$IMAGE_NAME"
;;
dreamone)
echo "> Device detected: Dream One"
sleep 3
IMAGE_NAME="Merlin_OE-2.6-dreamone-experimental-20241130.tar.xz"
DOWNLOAD_URL="https://merlinfeed.boxpirates.to/images_oe_2.6/$IMAGE_NAME"
;;
dreamtwo)
echo "> Device detected: Dream Two"
sleep 3
IMAGE_NAME="Merlin_OE-2.6-dreamtwo-experimental-20241130.tar.xz"
DOWNLOAD_URL="https://merlinfeed.boxpirates.to/images_oe_2.6/$IMAGE_NAME"
;;
dm520)
echo "> Device detected: DM520"
sleep 3
IMAGE_NAME="Merlin_OE-2.5-dm520-experimental-20241130.tar.xz"
DOWNLOAD_URL="https://merlinfeed.boxpirates.to/images_oe_2.5/$IMAGE_NAME"
;;
dm820)
echo "> Device detected: DM820"
sleep 3
IMAGE_NAME="Merlin_OE-2.5-dm820-experimental-20241130.tar.xz"
DOWNLOAD_URL="https://merlinfeed.boxpirates.to/images_oe_2.5/$IMAGE_NAME"
;;
dm7080)
echo "> Device detected: DM7080"
sleep 3
IMAGE_NAME="Merlin_OE-2.5-dm7080-experimental-20241130.tar.xz"
DOWNLOAD_URL="https://merlinfeed.boxpirates.to/images_oe_2.5/$IMAGE_NAME"
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


