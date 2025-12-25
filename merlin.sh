#!/bin/bash

detect_box() {
    if [ -f /proc/device-tree/model ]; then
        MODEL=$(tr -d '\0' < /proc/device-tree/model)
        case "$MODEL" in
            *"dm900"*) echo "dm900" ;;
            *"dm920"*) echo "dm920" ;;
            *"one"*) echo "dreamone" ;;
            *"two"*) echo "dreamtwo" ;;
            *"dm520"*) echo "dm520" ;;
            *"dm820"*) echo "dm820" ;;
            *"dm7080"*) echo "dm7080" ;;
            *) ;;
        esac
    fi
    
    if [ -z "$BOXNAME" ] && [ -f /etc/hostname ]; then
        BOXNAME=$(head -n 1 /etc/hostname 2>/dev/null | tr -d '\n\r')
        echo "$BOXNAME" | tr '[:upper:]' '[:lower:]'
    fi
    
    if [ -z "$BOXNAME" ]; then
        DMESG_OUTPUT=$(dmesg 2>/dev/null | grep -i "machine:" | head -1)
        case "$DMESG_OUTPUT" in
            *"dm900"*) echo "dm900" ;;
            *"dm920"*) echo "dm920" ;;
            *"one"*) echo "dreamone" ;;
            *"two"*) echo "dreamtwo" ;;
            *"dm520"*) echo "dm520" ;;
            *"dm820"*) echo "dm820" ;;
            *"dm7080"*) echo "dm7080" ;;
            *) echo "unknown" ;;
        esac
    fi
}

BOXNAME=$(detect_box)
image='Merlin'
version='experimental'
today=$(date +%d-%m-%Y)

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
        echo "> Your device is not supported or could not be detected"
        echo "> Detected value: $BOXNAME"
        exit 1
        ;;
esac

echo "> $IMAGE_NAME image found ..."
sleep 5

ms=""
for ms in "/media/hdd" "/media/usb" "/media/mmc" "/media/ba" "/media/sdb1" "/media/sda1" "/media/sdc1" "/mnt/hdd" "/mnt/usb"
do
    if [ -d "$ms" ]; then
        if mount | grep -q "$ms " 2>/dev/null && [ -w "$ms" ]; then
            AVAILABLE_SPACE=$(df "$ms" | awk 'NR==2 {print $4}')
            if [ "$AVAILABLE_SPACE" -gt 512000 ]; then
                echo "> Mounted storage with sufficient space found at: $ms"
                mkdir -p "$ms/images" 2>/dev/null
                break
            else
                echo "> Warning: Insufficient space on $ms (available: $((AVAILABLE_SPACE/1024)) MB)"
                ms=""
            fi
        else
            ms=""
        fi
    fi
done

if [ -z "$ms" ]; then
    echo "> No writable mounted storage with sufficient space found."
    echo "> Please mount an external storage (USB/HDD) with at least 500MB free space."
    exit 1
fi
sleep 3

echo "> Downloading $image-$version image to $ms/images please wait..."
sleep 3

if command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget"
elif command -v curl >/dev/null 2>&1; then
    DOWNLOAD_CMD="curl"
else
    echo "> Error: Neither wget nor curl found. Please install one of them."
    exit 1
fi

echo "> Checking internet connection..."
if ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1; then
    echo "> Internet connection OK"
else
    echo "> Error: No internet connection detected"
    exit 1
fi

if [ "$DOWNLOAD_CMD" = "wget" ]; then
    echo "> Starting download with wget..."
    wget --tries=3 --timeout=30 --show-progress -qO "$ms/images/$IMAGE_NAME" "$DOWNLOAD_URL"
    DOWNLOAD_RESULT=$?
else
    echo "> Starting download with curl..."
    curl -L --connect-timeout 30 --retry 3 --progress-bar -o "$ms/images/$IMAGE_NAME" "$DOWNLOAD_URL"
    DOWNLOAD_RESULT=$?
fi

if [ $DOWNLOAD_RESULT -ne 0 ]; then
    echo "> Download failed with error code: $DOWNLOAD_RESULT"
    rm -f "$ms/images/$IMAGE_NAME" 2>/dev/null
    exit 1
fi

echo "> Download of $image-$version image to $ms/images is finished"
sleep 3

if [ ! -f "$ms/images/$IMAGE_NAME" ]; then
    echo "> Error: Downloaded file not found!"
    exit 1
fi

FILE_SIZE=$(stat -c%s "$ms/images/$IMAGE_NAME" 2>/dev/null || stat -f%z "$ms/images/$IMAGE_NAME" 2>/dev/null)
if [ "$FILE_SIZE" -lt 50000000 ]; then
    echo "> Error: Downloaded file seems too small ($((FILE_SIZE/1024/1024)) MB). Possibly invalid download."
    rm -f "$ms/images/$IMAGE_NAME"
    exit 1
fi

echo "> Image downloaded successfully. Size: $((FILE_SIZE/1024/1024)) MB"
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
            echo "> Failed to copy to $dir (permission denied or disk full?)"
        fi
        sleep 1
    fi
done

echo ""
echo "========================================"
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
echo ""
echo "========================================"

exit 0

