#!/bin/bash

# ==============================================================================
# wasta-core: app-installs.sh
#
#   2012-10-20 rik: Initial script - for Linux Mint 13 Maya Cinnamon
#   2013-01-03 rik: several adjustments, added superuser block.
#   2013-04-02 rik: Added "Make PDF Booklet" right click option
#   2013-06-12 rik: Added chmod 644 for copied resources.  Added a bit of 
#     testing logic to better support re-running.
#   2013-06-20 rik: Adding several adjustments:
#     - updating for Cinnamon 1.8.x compatibilty
#     - adding sil repository and basic sil fonts
#     - adding libreoffice 4.0 ppa
#     - replacing 'echo | tee ...' with one-liner sed append / delete
#   2013-08-14 jcl: Nemo Actions for A4 PDF booklet printing, image resizing.
#   2013-10-16 rik: Refactored into wasta-base-apps-upgrade.  Other sections moved
#     to wasta-base-setup preinst and postinst.
#   2013-11-26 jcl: superuser block: remove -l in su -l (wrong working directory
#     context) and added $* to pass command line parameters along.
#   2013-12-19 rik: locale cleanup, ia32-libs confirm for 64bit skype install
#     (this enables gtk theme to be used for 32bit apps, etc.)
#   2014-01-29 rik: added xmlstarlet
#   2014-02-03 rik: added extundelete
#   2014-06-02 rik: adding artha, glipper
#     - cleanup / updates for Mint 17
#     - adblock global firefox extension
#   2014-06-14 rik: removing skype autostart (now placed by wasta-base-setup
#       install).
#   2014-07-22 rik: adding btrfs-tools, imagemagick
#   2014-07-23 rik: adding linux-generic (to keep kernel up-to-date: mint
#     holds it back by using their "linux-kernel-generic" instead).
#   2014-07-25 rik: cleaning out prior adblock folder if found.
#   2014-12-17 rik: adding several apps for wl 14.04
#   2015-01-09 rik: adding LO 4.3 PPA here (won't force on users in postinst)
#   2015-01-21 rik: adding lightdm: can't login to gnome-shell from mdm
#   2015-06-18 rik: adding exfat-utils, exfat-fuse for exfat compatiblity
#   2015-07-27 rik: adding mdm: lightdm issues with cinnamon usb automount
#   2015-08-05 rik: adding error processing in case an apt command failed
#   2015-08-13 rik: holding casper, ubiquity-casper: new version 1.340.2 will
#     cause remastersys to go to a login screen when booting the Live Session
#   2015-08-15 rik: removing casper, ubiquity-casper hold (solved casper
#     issues.
#   2015-10-25 rik: refactoring for Ubuntu 15.10
#   2015-11-04 rik: adding mkusb-nox (usb-creator-gtk issue with 15.10)
#   2015-11-05 rik: adding tracker (gnome-shell file search / index tool)
#     - adding hddtemp
#     - adding gnome-sushi, unoconv (needed for sushi to show lo docs)
#   2015-11-10 rik: adding ubiquity (since needs tweaked in app-adjustments.sh)
#   2016-03-01 rik: minor updates for 16.04: removing clamtk-nautilus,
#     nautilus-converter, tracker*
#   2016-03-02 rik: adding glipper (gpaste seemed to hang Cinnamon 2.8?)
#   2016-04-27 rik: adding: goldendict, pandoc, vim
#     - removing: artha
#   2016-05-02 rik:
#     - removing:
#           - linux-firmware-nonfre: not available for xenial
#     - adding:
#           - audacity
#           - gimp
#           - zim, python-appindicator
#   2016-05-04 rik: adding:
#     - fbreader
#     - inkscape
#     - scribus
#   2016-07-28 rik: mtpfs, mtp-tools, sound-juicer, brasero additions
#   2016-08-22 rik: inotify-tools, wasta-ibus-xkb
#   2016-09-30 rik: adding "booketimposer" to replace pdfbklt
#     - removing gnome-sushi/unoconv since seems confusing for some
#   2016-10-05 rik: changing 'ubiquity' to install 'no-recommends' or else will
#     pull in all the kde dependencies.
#   2017-03-14 rik: adding bloom-desktop, art-of-reading, hfsprogs, gddrescue
#   2017-11-29 rik: initial bionic version: adding kdenlive, removing openshot,
#     adding gnome-software
#   2018-03-05 rik: adding dkms
#   2018-03-14 rik: various bionic updates
#   2018-04-03 rik: gnome-search-tool seems to have been removed from bionic?
#     - removing asunder (sound-juicer already included)
#     - adding gnome-calculator, gnome-logs, gnome-sytem-monitor, gucharmap
#     since bionic defaults are as snaps
#   2018-05-23 rik: adding catfish, redshift-gtk, papirus-icon-theme
#       nethogs, sil compact fonts
#   2018-05-30 jcl: adding libreoffice-gnome: ensure smb access works
#   2018-08-31 rik: adding LO 6.0 PPA
#     - adding wasta-remastersys conf update (formerly in wasta-multidesktop)
#   2018-08-31 rik: syncing with Google Sheet documentation, adding a few
#     extras such as silcc, teckit, easytag
#   2018-09-05 rik: adding fonts-sil-annapurna
#       - adding wasta-papirus papirus-icon-theme
#   2018-09-05 rik: removing clamtk.. too big (255+MB) and not useful enough
#   2018-09-10 rik: making apt 10periodic and 20auto-upgrades changes:
#     - Update-Package-Lists = 7
#     - Download-Upgradeable-Packages = 0
#     - Unattended-Upgrade = 0
#   2019-02-23 rik: adding LO 6.1 PPA, removing LO 6.0 PPA
#   2019-03-05 rik: add keymanapp/keyman PPA and gpg key
#   2019-03-12 rik: removing dkms (or else when install shim-signed through
#       ubiquity will be prompted for setting up secureboot key and since
#       ubiquity is running as non-interactive it will cause an error
#   2019-08-09 rik: adding LO 6.2 PPA, removing 6.1 PPA
#     - correcting lo installs to include libreoffice-gnome and libreoffice-gtk2
#       libreoffice-gtk3 is installed by libreoffice-gnome.
#   2019-08-23 rik: Add recommendations from Ruben: ncdu, sysstat, tldr
#
# ==============================================================================

# ------------------------------------------------------------------------------
# Check to ensure running as root
# ------------------------------------------------------------------------------
#   No fancy "double click" here because normal user should never need to run
if [ $(id -u) -ne 0 ]
then
    echo
    echo "You must run this script with sudo." >&2
    echo "Exiting...."
    sleep 5s
    exit 1
fi

# ------------------------------------------------------------------------------
# Function: aptError
# ------------------------------------------------------------------------------
aptError () {
    if [ "$AUTO" ];
    then
        echo
        echo "*** ERROR: apt-get command failed. You may want to re-run!"
        echo
    else
        echo
        echo "     --------------------------------------------------------"
        echo "     'APT' Error During Update / Installation"
        echo "     --------------------------------------------------------"
        echo
        echo "     An error was encountered with the last 'apt' command."
        echo "     You should close this script and re-start it, or"
        echo "     correct the error manually before proceeding."
        echo
        read -p "     Press any key to proceed..."
        echo
   fi
}

# ------------------------------------------------------------------------------
# Initial Setup
# ------------------------------------------------------------------------------

echo
echo "*** Script Entry: app-installs.sh"
echo
# Setup variables for later reference
DIR=/usr/share/wasta-core
SERIES=$(lsb_release -sc)

# if 'auto' parameter passed, run non-interactively
if [ "$1" == "auto" ];
then
    AUTO="auto"
    
    # needed for apt-get
    YES="--yes"
    DEBIAN_NONINTERACTIVE="env DEBIAN_FRONTEND=noninteractive"

    # needed for gdebi
    INTERACTIVE="-n"

    # needed for dpkg-reconfigure
    DPKG_FRONTEND="--frontend=noninteractive"
else
    AUTO=""
    YES=""
    DEBIAN_NONINTERACTIVE=""
    INTERACTIVE=""
    DPKG_FRONTEND=""
fi

# ------------------------------------------------------------------------------
# Configure sources and update settings and do update
# ------------------------------------------------------------------------------
echo
echo "*** Making adjustments to software repository sources"
echo

APT_SOURCES=/etc/apt/sources.list

if ! [ -e $APT_SOURCES.wasta ];
then
    APT_SOURCES=/etc/apt/sources.list
    APT_SOURCES_D=/etc/apt/sources.list.d
else
    # wasta-offline active: adjust apt file locations
    echo
    echo "*** wasta-offline active, applying repository adjustments to /etc/apt/sources.list.wasta"
    echo
    APT_SOURCES=/etc/apt/sources.list.wasta
    if [ -e /etc/apt/sources.list.d ];
    then
        echo
        echo "*** wasta-offline 'offline and internet' mode detected"
        echo
        # wasta-offline "offline and internet mode": no change to sources.list.d
        APT_SOURCES_D=/etc/apt/sources.list.d
    else
        echo
        echo "*** wasta-offline 'offline only' mode detected"
        echo
        # wasta-offline "offline only mode": change to sources.list.d location
        APT_SOURCES_D=/etc/apt/sources.list.d.wasta
    fi
fi

# first backup $APT_SOURCES in case something goes wrong
# delete $APT_SOURCES.save if older than 30 days
find /etc/apt  -maxdepth 1 -mtime +30 -iwholename $APT_SOURCES.save -exec rm {} \;

if ! [ -e $APT_SOURCES.save ];
then
    cp $APT_SOURCES $APT_SOURCES.save
fi

# Manually add repo keys:
#   - apt-key no longer supported in scripts so need to use gpg directly.
#       - Still works 18.04 but warning it may break in the future: however
#         the direct gpg calls were problematic so keeping same for bionic.
#   - sending output to null to not scare users
apt-key add $DIR/keys/libreoffice-ppa.gpg > /dev/null 2>&1
apt-key add $DIR/keys/keymanapp-ppa.gpg > /dev/null 2>&1
apt-key add $DIR/keys/skype.gpg > /dev/null 2>&1

# add LibreOffice 6.2 PPA
 if ! [ -e $APT_SOURCES_D/libreoffice-ubuntu-libreoffice-6-2-$SERIES.list ];
 then
     echo
     echo "*** Adding LibreOffice 6.2 PPA"
     echo
     echo "deb http://ppa.launchpad.net/libreoffice/libreoffice-6-2/ubuntu $SERIES main" | \
         tee $APT_SOURCES_D/libreoffice-ubuntu-libreoffice-6-2-$SERIES.list
     echo "# deb-src http://ppa.launchpad.net/libreoffice/libreoffice-6-2/ubuntu $SERIES main" | \
         tee -a $APT_SOURCES_D/libreoffice-ubuntu-libreoffice-6-2-$SERIES.list
 else
     # found, but ensure LibreOffice PPA ACTIVE (user could have accidentally disabled)
     # DO NOT match any lines ending in #wasta
     sed -i -e '/#wasta$/! s@.*\(deb http://ppa.launchpad.net\)@\1@' \
        $APT_SOURCES_D/libreoffice-ubuntu-libreoffice-6-2-$SERIES.list
 fi

echo
echo "*** Removing Older LibreOffice PPAs"
echo
rm -f $APT_SOURCES_D/libreoffice-ubuntu-libreoffice-6-0*
rm -f $APT_SOURCES_D/libreoffice-ubuntu-libreoffice-6-1*

# Add Skype repository
if ! [ -e $APT_SOURCES_D/skype-stable.list ];
then
    echo
    echo "*** Adding Skype Repository"
    echo

    echo "deb https://repo.skype.com/deb stable main" | \
        tee $APT_SOURCES_D/skype-stable.list
fi

# add Keyman PPA
if ! [ -e $APT_SOURCES_D/keymanapp-ubuntu-keyman-$SERIES.list ];
then
    echo
    echo "*** Adding Keyman PPA"
    echo
    echo "deb http://ppa.launchpad.net/keymanapp/keyman/ubuntu $SERIES main" | \
        tee $APT_SOURCES_D/keymanapp-ubuntu-keyman-$SERIES.list
    echo "# deb-src http://ppa.launchpad.net/keymanapp/keyman/ubuntu $SERIES main" | \
        tee -a $APT_SOURCES_D/keymanapp-ubuntu-keyman-$SERIES.list
 else
     # found, but ensure Keyman PPA ACTIVE (user could have accidentally disabled)
     # DO NOT match any lines ending in #wasta
     sed -i -e '/#wasta$/! s@.*\(deb http://ppa.launchpad.net\)@\1@' \
        $APT_SOURCES_D/keymanapp-ubuntu-keyman-$SERIES.list
fi

# 2017-11-29 rik: NOTE: pfsense caching will NOT work with this no-cache option
#   set to True.  So disabling for bionic for now until get more input from
#   other users (but Ethiopia for example will want this set to False)
#if ! [ -e /etc/apt/apt.conf.d/99nocache ];
#then
#    echo 'Acquire::http::No-Cache "True";' > /etc/apt/apt.conf.d/99nocache
#fi

apt-get update

    LASTERRORLEVEL=$?
    if [ "$LASTERRORLEVEL" -ne "0" ];
    then
        aptError
    fi

# ------------------------------------------------------------------------------
# Upgrade ALL
# ------------------------------------------------------------------------------

echo
echo "*** Install All Updates"
echo

$DEBIAN_NONINERACTIVE apt-get $YES dist-upgrade

    LASTERRORLEVEL=$?
    if [ "$LASTERRORLEVEL" -ne "0" ];
    then
        aptError
    fi

# ------------------------------------------------------------------------------
# Standard package installs for all systems
# -----------------------------------------ri-------------------------------------

echo
echo "*** Standard Installs"
echo

# adobe-flashplugin: flash
# aisleriot: solitare game
# android-tools-adb: terminal - communicate to Android devices
# apt-rdepends: reverse dependency lookup
# audacity lame: audio editing
# bloom-desktop art-of-reading3: sil bloom
# bookletimposer: pdf booklet / imposition tool
# brasero: CD/DVD burner
# btrfs-tools: filesystem utilities
# catfish: more in-depth search than nemo gives (gnome-search-tool not available)
# cheese: webcam recorder, picture taker
# cifs-utils: "common internet filesystem utils" for fileshare utilities, etc.
# curl: terminal - download utility
# dconf-cli, dconf-tools: gives tools for making settings adjustments
# debconf-utils: needed for debconf-get-selections, etc. for debconf configure
# diodon: clipboard manager
# dos2unix: terminal - convert line endings of files to / from windows to unix
# easytag: GUI ID3 tag editor
# exfat-fuse, exfat-utils: compatibility for exfat formatted disks
# extundelete: terminal - restore deleted files
# fbreader: e-book reader
# font-manager: GUI for managing fonts
# fonts-crosextra-caladea: metrically compatible with "Cambria"
# fonts-crosextra-carlito: metrically compatible with "Calibri"
# fonts-sil-*: standard SIL fonts
# gcolor3: color pickerg
# gddrescue: data recovery tool
# gdebi: graphical .deb installer
# gimp: advanced graphics editor
# git: terminal - command-line git
# goldendict: more advanced dictionary/thesaurus tool than artha
# gnome-calculator
# gnome-clocks: multi-timezone clocks, timers, alarms
# gnome-font-viewer: better than "font-manager" for just viewing a font file.
# gnome-logs: GUI log viewer
# gnome-maps: GUI map viewer
# gnome-nettool: network tool GUI (traceroute, lookup, etc)
# gnome-system-monitor:
# gparted: partition manager
# grsync: GUI rsync tool
# gucharmap: gnome character map (traditional)
# gufw: GUI for "uncomplicated firewall"
# hardinfo: system profiler
# hddtemp: terminal - harddrive temp checker
# hfsprogs: for apple hfs compatiblity
# htop: process browser
# httrack: website download utility
# imagemagick: terminal - image resizing, etc. (needed for nemo
#   image resize action)
# inkscape: vector graphics editor
# inotify-tools: terminal - watch for file changes
# iperf: terminal - network bandwidth measuring
# kdenlive: video editor
# keepassxc: password manager (xc is the community port that is more up to date)
# keyman: keyman keyboard app
# klavaro: typing tutor
# kmfl-keyboard-ipa: ipa keyboard for kmfl
# libdvd-pkg: enables DVD playback (downloads and installs libdvdcss2)
# libreoffice-base:
# libreoffice-gnome: bionic: this includes -gtk3 which is needed for samba
# libreoffice-gtk2: bionic: note that -gtk2 can't open samba files
# libreoffice-sdbc-hsqldb: db backend for LO base
# libreoffice-style-tango: color icon set (more usable than 14.04 "human")
# libtext-pdf-perl: provides pdfbklt (make A5 booklet from pdf)
# meld nautilus-compare: graphical text file compare utility
# mkusb-nox: teminal usb creator (15.10 issue with usb-creator-gtk)
# modem-manager-gui: Check balance, top up, check signal strength, etc.
# mtp-tools: media-transfer-protocol tools: needed for smartphones
# myspell-en-gb: spell checker for English (UK): needed for Libre Office
# nautilus-compare: nautilus integration with meld
# ncdu: terminal - ncurses disk usage analyzer tool
# nethogs: CLI network monitor showing per application net usage
# net-tools: terminal - basic utilities like ifconfig
# pandoc: terminal - general markup converter
# papirus-icon-theme:
# pinta: MS Paint alternative: more simple for new users than gimp
# qt5-style-plugins: needed for qt5 / gtk theme compatibility
# redshift-gtk: redshift for blue light reduction
# rhythmbox: music manager
# shotwell: photo editor / manager (can edit single files easily)
# silcc: terminal - SIL consistent changes
# simplescreenrecorder: screen recorder 
# skypeforlinux: skype
# soundconverter: convert audio formats
# sound-juicer: rip CDs
# ssh: terminal - remote access
# synaptic: more advanced package manager
#   - apt-xapian-index: for synpatic indexing
# sysstat: terminal - provides sar: system activity reporter
# teckit: terminal - SIL teckit
# testdisk: terminal - photorec tool for recovery of deleted files
# thunderbird xul-ext-lightning: GUI email client
# tldr: terminal - gives 'tldr' summary of manpages
# tlp: laptop power savings
# traceroute: terminal
# ttf-mscorefonts-installer: installs standard Microsoft fonts
# ubiquity-frontend-gtk: add here so not needed to be downloaded by
#   wasta-remastersys or if needs to be updated by app-adjustments.sh
# ubiquity-slideshow-wasta:
# ubuntu-software: not great but currently no better option
# ubuntu-restricted-extras: mp3, flash, etc.
# ubuntu-wallpapers-*: wallpaper collections
# uget uget-integrator: GUI download manager (DTA in Firefox abandoned)
# vim-tiny: terminal - text editor (don't want FULL vim or else in main menu)
# vlc: play any audio or video files
# wasta-backup: GUI for rdiff-backup
# wasta-ibus-bionic: wasta customization of ibus
# wasta-menus: applicationmenu limiting system
# wasta-offline wasta-offline-setup: offline updates and installs
# wasta-papirus papirus-icon-theme: more 'modern' icon theme
# wasta-remastersys: create ISO of system
# wasta-resources-core: wasta-core documentation and resources
# wavemon: terminal - for wireless network diagonstics
# xmlstarlet: terminal - reading / writing to xml files
# xsltproc: terminal - xslt, xml conversion program
# xul-ext-lightning: Thunderbird Lightning (calendar) Extension
# youtube-dl: terminal - youtube / video downloads
# zim, python-appindicator: wiki style note taking app

$DEBIAN_NONINERACTIVE bash -c "apt-get $YES install \
    adobe-flashplugin \
    aisleriot \
    android-tools-adb \
    apt-rdepends \
    apt-xapian-index \
    audacity lame \
    bloom-desktop \
        art-of-reading3 \
    bookletimposer \
    brasero \
    btrfs-tools \
    catfish \
    cheese \
    cifs-utils \
    curl \
    dconf-cli \
        dconf-tools \
    debconf-utils \
    diodon \
    dos2unix \
    easytag \
    exfat-fuse \
        exfat-utils \
    extundelete \
    fbreader \
    font-manager \
    fonts-crosextra-caladea \
    fonts-crosextra-carlito \
    fonts-sil-andika \
        fonts-sil-andika-compact \
        fonts-sil-annapurna \
        fonts-sil-charis \
        fonts-sil-charis-compact \
        fonts-sil-doulos \
        fonts-sil-doulos-compact \
        fonts-sil-gentiumplus \
        fonts-sil-gentiumplus-compact \
    gcolor3 \
    gddrescue \
    gdebi \
    gimp \
    git \
    goldendict \
        goldendict-wordnet \
    gnome-calculator \
    gnome-clocks \
    gnome-font-viewer \
    gnome-logs \
    gnome-maps \
    gnome-nettool \
    gnome-screenshot \
    gnome-system-monitor \
    gparted \
    grsync \
    gucharmap \
    gufw \
    hardinfo \
    hddtemp \
    hfsprogs \
    htop \
    httrack \
    imagemagick \
    inkscape \
    inotify-tools \
    iperf \
    kdenlive \
    keepassxc \
    keyman \
    klavaro \
    kmfl-keyboard-ipa \
    libdvd-pkg \
    libreoffice-base \
        libreoffice-gnome \
        libreoffice-gtk2 \
        libreoffice-sdbc-hsqldb \
        libreoffice-style-tango \
    libtext-pdf-perl \
    meld \
        nautilus-compare \
    mkusb-nox \
    modem-manager-gui \
    mtp-tools \
    ncdu \
    nethogs \
    net-tools \
    pandoc \
    papirus-icon-theme \
    pinta \
    python-appindicator \
    qt5-style-plugins \
    redshift-gtk \
    rhythmbox \
    shotwell \
    silcc \
    simplescreenrecorder \
    skypeforlinux \
    soundconverter \
    sound-juicer \
    ssh \
    sysstat \
    synaptic apt-xapian-index \
    teckit \
    testdisk \
    thunderbird xul-ext-lightning \
    tldr \
    tlp \
    traceroute \
    ttf-mscorefonts-installer \
    ubiquity-frontend-gtk \
    ubiquity-slideshow-wasta \
    ubuntu-software \
    ubuntu-restricted-extras \
    uget uget-integrator \
    vim-tiny \
    vlc \
    wasta-backup \
    wasta-ibus-bionic \
    wasta-menus \
    wasta-offline wasta-offline-setup \
    wasta-papirus papirus-icon-theme \
    wasta-remastersys \
    wasta-resources-core \
    wavemon \
    xmlstarlet \
    xsltproc \
    youtube-dl \
    zim python-appindicator \
    "

    LASTERRORLEVEL=$?
    if [ "$LASTERRORLEVEL" -ne "0" ];
    then
        aptError
    fi

# ------------------------------------------------------------------------------
# Language Support Files: install
# -----------------------------------------------------------------------------
echo
echo "*** Installing Language Support Files"
echo

SYSTEM_LANG=$(locale | grep LANG= | cut -d= -f2 | cut -d_ -f1)
INSTALL_APPS=$(check-language-support -l $SYSTEM_LANG)

apt-get $YES install $INSTALL_APPS

# ------------------------------------------------------------------------------
# 32-bit installs if needed for 64 bit machines
# ------------------------------------------------------------------------------
# get machine architecture so will either install 64bit or 32bit
#MACHINE_TYPE=$(uname -m)

# **** NEEDED for 18.04 BIONIC *****??
# if [ $MACHINE_TYPE == 'x86_64' ];
# then
#     echo
#     echo "*** 64-bit detected. Installing packages for 32-bit apps"
#     echo
#     # packages needed for skype, etc. to be able to match gtk theme
#     # always assume yes
#     apt-get --yes install gtk2-engines-murrine:i386 gtk2-engines-pixbuf:i386
#     LASTERRORLEVEL=$?
#     if [ "$LASTERRORLEVEL" -ne "0" ];
#     then
#         aptError
#     fi
# fi

# ------------------------------------------------------------------------------
# wasta-remastersys conf updates
# ------------------------------------------------------------------------------
WASTA_REMASTERSYS_CONF=/etc/wasta-remastersys/wasta-remastersys.conf
if [ -e "$WASTA_REMASTERSYS_CONF" ];
then
    # change to wasta-linux splash screen
    sed -i -e 's@SPLASHPNG=.*@SPLASHPNG="/usr/share/wasta-core/resources/wasta-linux-vga.png"@' \
        "$WASTA_REMASTERSYS_CONF"
    
    # set default CD Label and ISO name
    WASTA_ID="$(sed -n "\@^ID=@s@^ID=@@p" /etc/wasta-release)"
    WASTA_VERSION="$(sed -n "\@^VERSION=@s@^VERSION=@@p" /etc/wasta-release)"
    ARCH=$(uname -m)
    if [ $ARCH == 'x86_64' ];
    then
        WASTA_ARCH="64bit"
    else
        WASTA_ARCH="32bit"
    fi
    WASTA_DATE=$(date +%F)

    #shortening CUSTOMISO since if it is too long wasta-remastersys will fail
    sed -i -e "s@LIVECDLABEL=.*@LIVECDLABEL=\"$WASTA_ID $WASTA_VERSION $WASTA_ARCH\"@" \
           -e "s@CUSTOMISO=.*@CUSTOMISO=\"WL-$WASTA_VERSION-$WASTA_ARCH.iso\"@" \
           -e "s@SLIDESHOW=.*@SLIDESHOW=wasta@" \
        "$WASTA_REMASTERSYS_CONF"
fi

# ------------------------------------------------------------------------------
# Reconfigure libdvd-pkg to get libdvdcss2 installed
# ------------------------------------------------------------------------------
# during the install of libdvd-pkg it can't in turn install libdvdcss2 since
#   another dpkg process is already active, so need to do it again
dpkg-reconfigure $DPKG_FRONTEND libdvd-pkg

# ------------------------------------------------------------------------------
# Clean up apt cache
# ------------------------------------------------------------------------------
# not doing since we may want those packages for wasta-offline
#apt-get autoremove
#apt-get autoclean

echo
echo "*** Script Exit: app-installs.sh"
echo

exit 0
