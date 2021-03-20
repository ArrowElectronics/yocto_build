#!/bin/bash
cd ~/work
mkdir build-av96
cd build-av96
git config --global user.email "$GIT_USEREMAIL"
git config --global user.name "$GIT_USERNAME"
git config --global color.ui false
if [ ! -f ./build-openstlinuxweston-stm32mp1-av96/conf/local.conf ]; then
  repo init -u https://github.com/dh-electronics/manifest-av96 -b dunfell
  repo sync
fi
source layers/meta-arrow/scripts/init-build-env.sh
bitbake av96-weston
