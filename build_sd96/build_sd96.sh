#!/bin/bash
cd ~/work
mkdir build-sd96
cd build-sd96
git config --global user.email "$GIT_USEREMAIL"
git config --global user.name "$GIT_USERNAME"
git config --global color.ui false

if [ ! -f ./poky/build-sd96/conf/local.conf ]; then
  repo init -u https://github.com/ArrowElectronics/meta-sd96.git -b dunfell
  repo sync
fi

cd poky/
export TEMPLATECONF=${TEMPLATECONF:-../meta-atmel/conf}
export MACHINE=sama5d27-sd96
source oe-init-build-env build-sd96
bitbake hostapd-image
