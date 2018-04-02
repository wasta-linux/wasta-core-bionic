#!/bin/bash

# ==============================================================================
# wasta-core: app-removals.sh
#
#   This script will remove apps deemed "unnecessary" for default users.
#
#   2013-10-16 rik: initial script
#   2013-11-26 jcl: superuser block: remove -l in su -l (wrong working directory
#       context) and added $* to pass command line parameters along.
#   2014-12-17 rik: adding software-center: now defaulting to mintinstall since
#       it works with wasta-offline.  USC doesn't.
#   2015-01-22 rik: adding mdm: now use lightdm
#   2015-07-27 rik: adding lightdm: now use mdm :-)
#   2015-10-25 rik: refactoring for Ubuntu 15.10 base
#   2015-11-04 rik: removing overlay-scrollbar* (15.10 still used for gtk2)\
#   2015-11-08 rik: removing appmenu-qt5: this prevents vlc from showing
#       in system tray.  See bug report:
#       https://bugs.launchpad.net/ubuntu/+source/appmenu-qt5/+bug/1514147
#   2016-03-01 rik: not removing appmenu-qt5 for 16.04.  Also not removing
#       adobe-flash-properties-gtk as it isn't found in 16.04.
#   2016-03-13 rik: NOT removing overlay-scrollbars or webapps-common, as then
#       unity-tweak-tool won't run correctly.  Instead using gschema.override
#       to not use these 2 "features".
#   2016-05-02 rik: NOT removing checkbox-common, webrowser-app, xterm since
#       have unintended consequences.  Instead will need to use adjustments
#       to hide them.
#   2016-05-04 rik: if attempting to remove a package that doesn't exist (such
#       as can happen when using wasta-offline "offline only mode") apt-get purge
#       will error and not remove anything.  So instead generating list of
#       packages that are installed to remove.
#   2016-09-30 rik: adding fonts-noto-cjk (conflicts with font manager)
#       - adding gnome-sushi, nemo-preview (confusing for some)
#   2016-10-02 rik: adding gnome-flashback, mpv
#   2016-11-09 rik: adding 'whoopsie'
#   2018-02-28 rik: removing gnome-software (for bionic we will need to use it)
#   2018-03-14 rik: adding libreoffice-gtk3 (justin recommends -gtk2)
#   2018-04-02 rik: adding blueman and metacity-common (not sure why cinnamon
#       lists them as 'recommends')
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
# Initial Setup
# ------------------------------------------------------------------------------

echo
echo "*** Script Entry: app-removals.sh"
echo
# Setup Diretory for later reference
DIR=/usr/share/wasta-core

# if 'auto' parameter passed, run non-interactively
if [ "$1" == "auto" ];
then
    AUTO="auto"
    
    # needed for apt-get
    YES="--yes"
else
    AUTO=""
    YES=""
fi

# ------------------------------------------------------------------------------
# Base Packages to remove for all systems
# ------------------------------------------------------------------------------

echo
echo "*** Removing Unwanted Applications"
echo

# blueman: not sure why cinnamon has this listed as a 'recommends'
# checkbox-common:
#   - but removing it will remove ubuntu-desktop so not removing
# deja-dup: we use wasta-backup
# empathy: chat client
# fonts-noto-cjk: conflicts with font-manager: newer font-manager from ppa
#       handles it, but it is too different to use
# fonts-*: non-english fonts
# gcolor2: color picker (but we upgraded to gcolor3)
# gdm: gnome display manager (we use lightdm)
# glipper: we now use diodon
# gnome-flashback: not sure how this got installed, but don't want as default
# gnome-orca: screen reader
# gnome-sushi unoconv:confusing for some
# landscape-client-ui-install: pay service only for big corporations
# libreoffice-gtk3: Justin recommends using -gtk2 for 18.04
# metacity-common: not sure why cinnamon has this listed as a 'recommends'
# mpv: media player - not sure how this got installed
# nemo-preview: confusing for some
# totem: not needed as vlc handles all video/audio
# transmission: normal users doing torrents probably isn't preferred
# ttf-* fonts: non-english font families
# unity-webapps-common: amazon shopping lens, etc.
# webbrowser-app: ubuntu web browser brought in by unity-tweak-tool
# whoopsie: ubuntu crash report system but hangs shutdown
# xterm:
#   - removing it will remove scripture-app-builder, etc. so not removing

# 2016-05-04 rik: if attempting to remove a package that doesn't exist (such
#   as can happen when using wasta-offline "offline only mode") apt-get purge
#   will error and not remove anything.  So instead found this way to do it:
#       http://superuser.com/questions/518859/ignore-packages-that-are-not-currently-installed-when-using-apt-get-remove
pkgToRemoveListFull="\
    blueman \
    deja-dup \
    empathy-common \
    fonts-noto-cjk \
    fonts-*tlwg* \
        fonts-khmeros-core \
        fonts-lao \
        fonts-nanum \
        fonts-takao-pgothic \
    gcolor2 \
    gdm \
    glipper \
    gnome-flashback \
    gnome-orca \
    gnome-sushi unoconv \
    landscape-client-ui-install \
    libreoffice-gtk3 \
    metacity-common \
    mpv \
    nemo-preview \
    totem \
        totem-common \
        totem-plugins \
    transmission-common \
    ttf-indic-fonts-core \
        ttf-kacst-one \
        ttf-khmeros-core \
        ttf-punjabi-fonts \
        ttf-takao-pgothic \
        ttf-thai-tlwg \
        ttf-unfonts-core \
        ttf-wqy-microhei \
    unity-webapps-common \
    webbrowser-app \
    whoopsie"

pkgToRemoveList=""
for pkgToRemove in $(echo $pkgToRemoveListFull); do
  $(dpkg --status $pkgToRemove &> /dev/null)
  if [[ $? -eq 0 ]]; then
    pkgToRemoveList="$pkgToRemoveList $pkgToRemove"
  fi
done

apt-get $YES purge $pkgToRemoveList

# ------------------------------------------------------------------------------
# run autoremove to cleanout unneeded dependent packages
# ------------------------------------------------------------------------------
# 2016-05-04 rik: adding --purge so extra cruft from packages cleaned up
apt-get $YES --purge autoremove

echo
echo "*** Script Exit: app-removals.sh"
echo

exit 0
