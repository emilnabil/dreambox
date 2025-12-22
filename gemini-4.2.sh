#!/bin/bash
# command=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/gemini-4.2.sh -O - | /bin/sh
####################
# configuration
#########################################
BOXNAME=$(head -n 1 /etc/hostname 2>/dev/null)
image='Gemini-4.2'
version='image'
today=$(date +%d-%m-%Y)

#########################################
case "$BOXNAME" in
    dm900)
        echo "> Device detected: ARM - DM900"
        sleep 3
        IMAGE_NAME="DM4U-gemini4.2-unstable-OE25-image-dm900-20230305220019.tar.xz"
        DOWNLOAD_URL="https://gist.dreambox4u.com/download.php?dir=images&sub=dreambox&file=$IMAGE_NAME"
        ;;
    dm920)
        echo "> Device detected: ARM - DM920"
        sleep 3
        IMAGE_NAME="DM4U-gemini4.2-unstable-OE25-image-dm920-20230305220646.tar.xz"
        DOWNLOAD_URL="https://gist.dreambox4u.com/download.php?dir=images&sub=dreambox&file=$IMAGE_NAME"
        ;;
    dreamone)
        echo "> Device detected: Dream One"
        sleep 3
        IMAGE_NAME="DM4U-gemini4.2-unstable-OE26-image-dreamone-20230305221311.tar.xz"
        DOWNLOAD_URL="https://gist.dreambox4u.com/download.php?dir=images&sub=dreambox&file=$IMAGE_NAME"
        ;;
    dreamtwo)
        echo "> Device detected: Dream Two"
        sleep 3
        IMAGE_NAME="DM4U-gemini4.2-unstable-OE26-image-dreamtwo-20230305222015.tar.xz"
        DOWNLOAD_URL="https://gist.dreambox4u.com/download.php?dir=images&sub=dreambox&file=$IMAGE_NAME"
        ;;
    dm520)
        echo "> Device detected: DM520"
        sleep 3
        IMAGE_NAME="DM4U-gemini4.2-unstable-OE25-image-dm520-20230305214028.tar.xz"
        DOWNLOAD_URL="https://gist.dreambox4u.com/download.php?dir=images&sub=dreambox&file=$IMAGE_NAME"
        ;;
    dm820)
        echo "> Device detected: DM820"
        sleep 3
        IMAGE_NAME="DM4U-gemini4.2-unstable-OE25-image-dm820-20230305214706.tar.xz"
        DOWNLOAD_URL="https://gist.dreambox4u.com/download.php?dir=images&sub=dreambox&file=$IMAGE_NAME"
        ;;
    dm7080)
        echo "> Device detected: DM7080"
        sleep 3
        IMAGE_NAME="DM4U-gemini4.2-unstable-OE25-image-dm7080-20230305215343.tar.xz"
        DOWNLOAD_URL="https://gist.dreambox4u.com/download.php?dir=images&sub=dreambox&file=$IMAGE_NAME"
        ;;
    *)
        echo "> Your device is not supported or /etc/hostname not found"
        exit 1
        ;;
esac

echo "> $IMAGE_NAME image found ..."
sleep 2
###########
ms=""
for ms in "/media/hdd" "/media/usb" "/media/mmc" "/media/ba"
do
    if mount | grep -q "$ms" 2>/dev/null; then
        echo "> Mounted storage found at: $ms"
        mkdir -p "$ms/images" 2>/dev/null
        if [ -w "$ms" ]; then
            break
        else
            echo "> Warning: No write permission on $ms"
            ms=""
        fi
    fi
done

if [ -z "$ms" ]; then
    echo "> No writable mounted storage found. Please mount your external memory and try again."
    echo "> Checked paths: /media/hdd, /media/usb, /media/mmc, /media/ba"
    exit 1
fi
sleep 2
###########
echo "> Downloading $image-$version image to $ms/images please wait..."
sleep 2

if command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget"
elif command -v curl >/dev/null 2>&1; then
    DOWNLOAD_CMD="curl"
else
    echo "> Error: Neither wget nor curl found. Please install one of them."
    exit 1
fi

if [ "$DOWNLOAD_CMD" = "wget" ]; then
    if wget -q --spider "$DOWNLOAD_URL" 2>/dev/null; then
        echo "> Starting download..."
        wget --show-progress -qO "$ms/images/$IMAGE_NAME" "$DOWNLOAD_URL"
        DOWNLOAD_RESULT=$?
    else
        echo "> Error: Cannot reach download server. Check your internet connection."
        exit 1
    fi
else
    if curl -s --head "$DOWNLOAD_URL" 2>/dev/null | head -n 1 | grep -q "200"; then
        echo "> Starting download..."
        curl -L --progress-bar -o "$ms/images/$IMAGE_NAME" "$DOWNLOAD_URL"
        DOWNLOAD_RESULT=$?
    else
        echo "> Error: Cannot reach download server. Check your internet connection."
        exit 1
    fi
fi

if [ $DOWNLOAD_RESULT -ne 0 ]; then
    echo "> Download failed with error code: $DOWNLOAD_RESULT"
    echo "> Check your internet connection and try again."
    exit 1
fi

echo "> Download of $image-$version image to $ms/images is finished"
sleep 2

if [ ! -f "$ms/images/$IMAGE_NAME" ]; then
    echo "> Error: Downloaded file not found!"
    exit 1
fi

FILE_SIZE=$(stat -c%s "$ms/images/$IMAGE_NAME" 2>/dev/null || stat -f%z "$ms/images/$IMAGE_NAME" 2>/dev/null)
if [ "$FILE_SIZE" -lt 1000000 ]; then
    echo "> Error: Downloaded file seems too small ($FILE_SIZE bytes). Possibly invalid download."
    rm -f "$ms/images/$IMAGE_NAME"
    exit 1
fi

echo "> Image downloaded successfully. Size: $(($FILE_SIZE/1024/1024)) MB"
sleep 2

echo "> Searching for multiboot backup folders..."
BACKUP_COPIED=0
for dir in "/media/hdd/backup/" "/media/usb/backup/" "/media/mmc/backup/" "/media/ba/backup/"
do
    if [ -d "$dir" ] && [ -w "$dir" ]; then
        echo "> $dir folder found and writable..."
        sleep 1
        echo "> Copying image to $dir folder please wait..."
        cp "$ms/images/$IMAGE_NAME" "$dir" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "> Successfully copied to $dir"
            BACKUP_COPIED=1
        else
            echo "> Failed to copy to $dir (permission denied?)"
        fi
        sleep 1
    fi
done

if [ $BACKUP_COPIED -eq 1 ]; then
    echo "> Process completed successfully!"
    echo "> Image saved to:"
    echo ">   - $ms/images/$IMAGE_NAME"
    for dir in "/media/hdd/backup/" "/media/usb/backup/" "/media/mmc/backup/" "/media/ba/backup/"
    do
        if [ -f "$dir$IMAGE_NAME" ]; then
            echo ">   - $dir$IMAGE_NAME"
        fi
    done
else
    echo "> Warning: No backup folders were found or writable."
    echo "> Image saved only to: $ms/images/$IMAGE_NAME"
fi

exit 0