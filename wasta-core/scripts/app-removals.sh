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
#   2018-05-23 rik: not removing metacity: this will cause cinnamon to be removed
#   2018-05-30 jcl: don't remove libreoffice-gtk3 - a dependency for -gnome
#   2018-08-25 rik: removing additional fonts to reduce font lists.  Users
#       needing them will need to add them back in their wasta-custom-* packages
#   2018-09-05 rik: removing snapd (over 800MB in /var/lib/snapd no way to
#       disable auto-updates).
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
# Ensure lightdm installed (so can remove gdm3 below)
# ------------------------------------------------------------------------------


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
# dkms: if installed then ubiquity will fail when installing shim-signed
#   because will need interaction to setup secureboot keys
# empathy: chat client
# fonts-noto-cjk: conflicts with font-manager: newer font-manager from ppa
#       handles it, but it is too different to use
# fonts-*: non-english fonts
# gcolor2: color picker (but we upgraded to gcolor3)
# glipper: we now use diodon
# gnome-flashback: not sure how this got installed, but don't want as default
# gnome-orca: screen reader
# gnome-sushi:confusing for some
# keepassx: keepassxc now preferred
# landscape-client-ui-install: pay service only for big corporations
# mpv: media player - not sure how this got installed
# nemo-preview: confusing for some
# snapd: see below
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
    dkms \
    empathy-common \
    fonts-beng* \
        fonts-deva* \
        fonts-gargi \
        fonts-gubbi \
        fonts-gujr* \
        fonts-guru* \
        fonts-indic \
        fonts-kacst* \
        fonts-kalapi \
        fonts-knda \
        fonts-khmeros-core \
        fonts-lao \
        fonts-lklug-sinhala \
        fonts-lohit* \
        fonts-mlym \
        fonts-nakula \
        fonts-navilu \
        fonts-nanum \
        fonts-noto-* \
        fonts-orya* \
        fonts-pagul \
        fonts-sahadeva \
        fonts-samyak* \
        fonts-sarai \
        fonts-sil-padauk \
        fonts-smc* \
        fonts-takao-pgothic \
        fonts-taml \
        fonts-telu* \
        fonts-tibetan-machine \
        fonts-*tlwg* \
        ttf-indic-fonts-core \
        ttf-kacst-one \
        ttf-khmeros-core \
        ttf-punjabi-fonts \
        ttf-takao-pgothic \
        ttf-thai-tlwg \
        ttf-unfonts-core \
        ttf-wqy-microhei \
    gcolor2 \
    glipper \
    gnome-flashback \
    gnome-orca \
    gnome-sushi unoconv \
    keepassx \
    landscape-client-ui-install \
    mpv \
    nemo-preview \
    snapd \
    totem \
        totem-common \
        totem-plugins \
    transmission-common \
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
# cleanup dangling folders
# ------------------------------------------------------------------------------
# some removals do not clean up after themselves
if [ ! -x /usr/bin/blueman-manager ];
then
    rm -rf /var/lib/blueman
fi

if [ ! -x /usr/bin/whoopsie ];
then
    rm -rf /var/lib/whoopsie
fi

# ------------------------------------------------------------------------------
# snap cleanup
# ------------------------------------------------------------------------------

#2018-09-05 rik: removing snapd from Wasta-Linux 18.04: installed
#   it takes up huge space (/var/lib/snapd is approx. 800MB) and 
#   there is no way to disable auto-updates which our users are not
#   going to be happy with
#
# rik: these snaps don't integrate well with the theme and are slow to start
#   so for 18.04 we will REMOVE them and install their traditional counterparts
#snap remove \
#    gnome-calculator \
#    gnome-characters \
#    gnome-logs \
#    gnome-system-monitor \
#    gnome-3-26-1604 \
#    gtk-common-themes

#rm /var/lib/snapd/snaps/*.snap
#rm /var/lib/snapd/seed/snaps/*.snap

# ------------------------------------------------------------------------------
# run autoremove to cleanout unneeded dependent packages
# ------------------------------------------------------------------------------
# 2016-05-04 rik: adding --purge so extra cruft from packages cleaned up
apt-get $YES --purge autoremove

echo
echo "*** Script Exit: app-removals.sh"
echo

exit 0
