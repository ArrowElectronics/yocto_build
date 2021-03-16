#!/bin/bash
cd ~/work
git config --global user.email "$GIT_USEREMAIL"
git config --global user.name "$GIT_USERNAME"
git config --global color.ui false
if [ ! -x I.IMX8_Thor96/Kernel_5_4_47/yocto_build_setup_thor96.sh ]; then
  git clone https://github.com/ArrowElectronics/I.IMX8_Thor96.git -b rel31_yocto_build
fi
cd I.IMX8_Thor96/Kernel_5_4_47
./yocto_build_setup_thor96.sh
