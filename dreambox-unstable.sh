#!/bin/bash
# command=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/dreambox-unstable.sh -O - | /bin/sh

#########################################
# configuration
#########################################
BOXNAME="$(cat /etc/hostname 2>/dev/null | tr -d '[:space:]')"
IMAGE_TAG="dreambox-unstable"
TODAY="$(date +%d-%m-%Y)"

#########################################
case "$BOXNAME" in
    dm900)
        echo "> Device detected: ARM - DM900"
        IMAGE_NAME="dreambox-image-deb-dm900-20211029.tar.xz"
        DOWNLOAD_URL="https://dreamboxupdate.com/opendreambox/2.5/unstable/images/dm900/dreambox-image-deb-dm900-20211029.tar.xz"
        ;;
    dm920)
        echo "> Device detected: ARM - DM920"
        IMAGE_NAME="dreambox-image-deb-dm920-20211029.tar.xz"
        DOWNLOAD_URL="https://dreamboxupdate.com/opendreambox/2.5/unstable/images/dm920/dreambox-image-deb-dm920-20211029.tar.xz"
        ;;
    dmone)
        echo "> Device detected: Dream One"
        IMAGE_NAME="dreambox-image-dreamone-20220224.tar.xz"
        DOWNLOAD_URL="https://dreamboxupdate.com/opendreambox/2.6/unstable/images/dreamone/dreambox-image-dreamone-20220224.tar.xz"
        ;;
    dmtwo)
        echo "> Device detected: Dream Two"
        IMAGE_NAME="dreambox-image-dreamtwo-20220224.tar.xz"
        DOWNLOAD_URL="https://dreamboxupdate.com/opendreambox/2.6/unstable/images/dreamtwo/dreambox-image-dreamtwo-20220224.tar.xz"
        ;;
    dm520)
        echo "> Device detected: DM520"
        IMAGE_NAME="dreambox-image-deb-dm520-20170216.tar.xz"
        DOWNLOAD_URL="https://dreamboxupdate.com/opendreambox/2.2/unstable/images/dm520/dreambox-image-deb-dm520-20170216.tar.xz"
        ;;
    dm820)
        echo "> Device detected: DM820"
        IMAGE_NAME="dreambox-image-deb-dm820-20160514.tar.xz"
        DOWNLOAD_URL="https://dreamboxupdate.com/opendreambox/2.2/stable/images/dm820/dreambox-image-deb-dm820-20160514.tar.xz"
        ;;
    dm7080)
        echo "> Device detected: DM7080"
        IMAGE_NAME="dreambox-image-deb-dm7080-20160514.tar.xz"
        DOWNLOAD_URL="https://dreamboxupdate.com/opendreambox/2.2/stable/images/dm7080/dreambox-image-deb-dm7080-20160514.tar.xz"
        ;;
    *)
        echo "> Your device is not supported or /etc/hostname not found"
        exit 1
        ;;
esac

sleep 2
echo "> $IMAGE_NAME image selected"

#########################################
MS=""
for p in /media/hdd /media/usb /media/mmc /media/ba; do
    if mountpoint -q "$p" 2>/dev/null; then
        mkdir -p "$p/images" 2>/dev/null
        if [ -w "$p/images" ]; then
            MS="$p"
            echo "> Mounted writable storage found at: $MS"
            break
        fi
    fi
done

if [ -z "$MS" ]; then
    echo "> No writable mounted storage found"
    exit 1
fi

#########################################
echo "> Downloading $IMAGE_TAG image to $MS/images ..."
sleep 2

if command -v wget >/dev/null 2>&1; then
    wget -q --spider "$DOWNLOAD_URL" || exit 1
    wget --show-progress -O "$MS/images/$IMAGE_NAME" "$DOWNLOAD_URL" || exit 1
elif command -v curl >/dev/null 2>&1; then
    curl -fsL --progress-bar -o "$MS/images/$IMAGE_NAME" "$DOWNLOAD_URL" || exit 1
else
    echo "> wget or curl not found"
    exit 1
fi

#########################################
if [ ! -f "$MS/images/$IMAGE_NAME" ]; then
    echo "> Download failed"
    exit 1
fi

FILE_SIZE=$(stat -c%s "$MS/images/$IMAGE_NAME" 2>/dev/null || stat -f%z "$MS/images/$IMAGE_NAME")
if [ "$FILE_SIZE" -lt 1000000 ]; then
    rm -f "$MS/images/$IMAGE_NAME"
    echo "> Invalid image size"
    exit 1
fi

echo "> Image downloaded successfully ($((${FILE_SIZE}/1024/1024)) MB)"

#########################################
BACKUP_COPIED=0
for b in /media/hdd/backup /media/usb/backup /media/mmc/backup /media/ba/backup; do
    if [ -d "$b" ] && [ -w "$b" ]; then
        cp "$MS/images/$IMAGE_NAME" "$b/" && BACKUP_COPIED=1
    fi
done

if [ "$BACKUP_COPIED" -eq 1 ]; then
    echo "> Image copied to backup folders successfully"
else
    echo "> No writable backup folders found"
fi

echo "> Done"
exit 0

