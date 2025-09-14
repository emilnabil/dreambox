reboot() { 
    echo "⚠ reboot command ignored" 
}

init() { 
    echo "⚠ init command ignored" 
}

shutdown() { 
    echo "⚠ shutdown command ignored" 
}

killall() {
    for arg in "$@"; do
        if [ "$arg" = "enigma2" ]; then
            echo "⚠ killall enigma2 command ignored"
            return 0
        fi
    done
    command killall "$@"
}

DISABLE_RESTART=${DISABLE_RESTART:-true}
LOG_FILE="/tmp/superscript_$(date +%F_%H-%M-%S).log"

exec 3>&1 1>>"$LOG_FILE" 2>&1
trap 'echo "⚠ Script interrupted. Check $LOG_FILE for details."; exit 1' INT TERM

printf "\n\n" >&3
echo "===========================================================" >&3
echo "     ★ Super_Script & Plugin Installer by Emil Nabil ★" >&3
echo "             Version: July 2025" >&3
echo "===========================================================" >&3
echo "Started at: $(date)" >&3
echo "" >&3
echo " �� Install tools & packages" >&3
echo " �� Install useful plugins" >&3
echo "" >&3

echo "==> Gathering system info..." >&3
[ -f /etc/image-version ] && grep -i 'distro' /etc/image-version | cut -d= -f2 >&3 || echo "⚠ No distro info found" >&3
[ -f /etc/hostname ] && cat /etc/hostname >&3 || echo "⚠ No hostname info found" >&3
ip -o -4 route show to default 2>/dev/null | awk '{print $5}' >&3 || echo "eth0" >&3
echo "" >&3

echo "==> Updating feed and packages..." >&3
if apt-get update >/dev/null 2>&1; then
    echo "✔ Feeds updated" >&3
else
    echo "⚠ Failed to update feeds, continuing anyway..." >&3
fi

if apt-get upgrade -y >/dev/null 2>&1; then
    echo "✔ Packages upgraded" >&3
else
    echo "⚠ Some packages failed to upgrade, continuing anyway..." >&3
fi
echo "" >&3

echo "==> Installing essential packages..." >&3
essential_packages=("xz" "curl" "wget" "ntpd")
for pkg in "${essential_packages[@]}"; do
    if apt-get install -y "$pkg" >/dev/null 2>&1; then
        echo "✔ $pkg installed" >&3
    else
        echo "⚠ Failed to install $pkg, skipping..." >&3
    fi
done
echo "" >&3

echo "==> Checking Python version..." >&3
if command -v python >/dev/null 2>&1 && python --version 2>&1 | grep -q '^Python 2\.'; then
    echo "✔ You have Python2" >&3
else
    echo "⚠ Python2 is required, but not found. Continuing anyway..." >&3
fi
echo "" >&3

echo "==> Installing required packages for Python2 ..." >&3
packages=(
    "wget" "curl" "hlsdl" "python-lxml" "python-requests"
    "python-beautifulsoup4" "python-cfscrape" "livestreamer"
    "python-six" "python-sqlite3" "python-pycrypto"
    "f4mdump" "python-image" "python-imaging" "python-argparse"
    "python-multiprocessing" "python-mmap" "python-ndg-httpsclient"
    "python-pydoc" "python-xmlrpc" "python-certifi" "python-urllib3"
    "python-chardet" "python-pysocks" "enigma2-plugin-systemplugins-serviceapp"
    "ffmpeg" "exteplayer3" "gstplayer" "gstreamer1.0-plugins-good"
    "gstreamer1.0-plugins-ugly" "gstreamer1.0-plugins-base" "gstreamer1.0-plugins-bad"
)
for package in "${packages[@]}"; do
    if ! dpkg -s "$package" >/dev/null 2>&1; then
        echo "Installing $package..." >&3
        if apt-get install -y "$package" >/dev/null 2>&1; then
            echo "✔ $package installed" >&3
        else
            echo "⚠ Failed to install $package, skipping..." >&3
        fi
    else
        echo "✔ $package is already installed" >&3
    fi
done

IPAUDIO_VER="6.6"

run_script() {
    local url="$1"
    local tmp_script="/tmp/plugin_installer_$(date +%s).sh"
    echo "▶ Downloading $url..." >&3
    if wget -q --timeout=10 --tries=2 -O "$tmp_script" "$url"; then
        if [ -s "$tmp_script" ]; then
            chmod +x "$tmp_script"
            if bash "$tmp_script"; then
                echo "✔ Script $url executed successfully" >&3
            else
                echo "⚠ Failed to execute script $url, skipping..." >&3
            fi
            rm -f "$tmp_script"
        else
            echo "⚠ Downloaded script $url is empty, skipping..." >&3
            rm -f "$tmp_script"
        fi
    else
        echo "⚠ Failed to download script $url, skipping..." >&3
    fi
}

echo "" >&3
echo "==> Installing Plugins ..." >&3
urls=(
    "http://dreambox4u.com/emilnabil237/plugins/ajpanel/installer.sh"
    "https://dreambox4u.com/emilnabil237/plugins/ajpanel/new/emil-panel-lite.sh"
    "https://dreambox4u.com/emilnabil237/plugins/ArabicSavior/installer.sh"
    "https://raw.githubusercontent.com/emilnabil/download-plugins/refs/heads/main/cccaminfo/cccaminfo_py2.sh"
    "https://dreambox4u.com/emilnabil237/plugins/crashlogviewer/CrashLogViewer.sh"
    "https://github.com/emilnabil/dreambox/raw/refs/heads/main/MenuSort.sh"
    "https://github.com/emilnabil/dreambox/raw/refs/heads/main/styles.sh"
    "https://github.com/emilnabil/dreambox/raw/refs/heads/main/StartUpService.sh"
    "https://raw.githubusercontent.com/emilnabil/download-plugins/refs/heads/main/EmilPanelPro/emilpanelpro.sh"
    "https://dreambox4u.com/emilnabil237/plugins/Epg-Grabber/installer.sh"
    "https://dreambox4u.com/emilnabil237/plugins/iptosat/installer.sh"
    "https://github.com/emilnabil/dreambox/raw/refs/heads/main/ipaudio-6.6.sh"
    "https://dreambox4u.com/emilnabil237/plugins/jedimakerxtream/installer.sh"
    "https://dreambox4u.com/emilnabil237/KeyAdder/installer.sh"
    "https://dreambox4u.com/emilnabil237/plugins/NewVirtualKeyBoard/installer.sh"
    "https://dreambox4u.com/emilnabil237/plugins/RaedQuickSignal/installer.sh"
    "https://dreambox4u.com/emilnabil237/plugins/xtreamity/installer.sh"
    "https://dreambox4u.com/emilnabil237/emu/installer-cccam.sh"
    "https://dreambox4u.com/emilnabil237/emu/installer-ncam.sh"
    "https://dreambox4u.com/emilnabil237/emu/installer-oscam.sh"
    "https://dreambox4u.com/emilnabil237/plugins/ipaudiopro/installer.sh"
)
for url in "${urls[@]}"; do
    run_script "$url"
    sleep 1
done

echo "" >&3
echo "==> Cleaning temporary files..." >&3
find /tmp -name "plugin_installer_*.sh" -delete && echo "✔ Temporary files cleaned" >&3 || echo "⚠ No temporary files found to clean" >&3
echo "" >&3

echo "#>>>>>> Uploaded By Emil Nabil <<<<<<<#" >&3
echo "✔ All steps completed successfully (with warnings if any)!" >&3

if [ "${DISABLE_RESTART,,}" = "true" ]; then
    echo "🔁 Restarting device to apply changes..." >&3
    sleep 4
    command killall -9 enigma2 || echo "⚠ Failed to restart enigma2, please restart manually" >&3
else
    echo "ℹ Restart skipped (DISABLE_RESTART = $DISABLE_RESTART)" >&3
fi

exit 0

