#!/bin/bash
cd ~/work
git config --global user.email "$GIT_USEREMAIL"
git config --global user.name "$GIT_USERNAME"
git config --global color.ui false
if [ ! -x I.IMX8X_AI_ML/Kernel_5_4_47/yocto_build_setup_aiml.sh ]; then
  git clone https://github.com/ArrowElectronics/I.IMX8X_AI_ML.git -b rel31_yocto_build
fi
cd I.IMX8X_AI_ML/Kernel_5_4_47
./yocto_build_setup_aiml.sh
