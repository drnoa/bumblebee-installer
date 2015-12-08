#!/bin/bash
# This script will help you install nvidia drivers and bumblebee

read -p "Type the nvidia driver Version you like to install. [ENTER] example: nvidia-355" nvididriver

if echo "$nvididriver" | grep -iq "nvidia-" ;then

  echo "** Remove old nvidia drivers**"
  apt-get remove --purge nvidia*
  apt-get remove --purge bumblebee*

  echo "** install basics**"
  apt-get --purge remove xserver-xorg-video-nouveau
  apt-get install linux-source && apt-get install linux-headers-$(uname -r)
  
  echo "** Backup the blacklist.conf to blacklist.conf.bak **"
  cp /etc/modprobe.d/blacklist.conf /etc/modprobe.d/blacklist.conf.bak
  echo "** add the nvidia drivers to the blacklist **"
  echo "# Necessary to install nvidia drivers" >> /etc/modprobe.d/blacklist.conf
  echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
  echo "blacklist lbm-nouveau" >> /etc/modprobe.d/blacklist.conf
  echo "blacklist nvidia-173" >> /etc/modprobe.d/blacklist.conf
  echo "blacklist nvidia-96" >> /etc/modprobe.d/blacklist.conf
  echo "blacklist nvidia-current" >> /etc/modprobe.d/blacklist.conf
  echo "blacklist nvidia-173-updates" >> /etc/modprobe.d/blacklist.conf
  echo "blacklist nvidia-96-updates" >> /etc/modprobe.d/blacklist.conf
  echo "alias nvidia nvidia_current_updates" >> /etc/modprobe.d/blacklist.conf
  echo "alias nouveau off" >> /etc/modprobe.d/blacklist.conf
  echo "alias lbm-nouveau off" >> /etc/modprobe.d/blacklist.conf
  echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist.conf
  
  echo "** Install the nvidia driver **"
  apt-get update && apt-get dist-upgrade -y
  apt-get install $nvididriver-updates nvidia-settings

  echo "** remove nvidia-prime **"
  apt-get remove --purge nvidia-prime
  
  echo "** Install the bumblebee driver **"
  apt-get install bumblebee bumblebee-nvidia virtualgl virtualgl-libs virtualgl-libs-ia32:i386 virtualgl-libs:i386
  usermod -a -G bumblebee $USER
  
  echo "** configure the bumblebee driver **"
  cd /etc/bumblebee
  ls -Al
  
  sed -i 's/nvidia-current/$nvididriver-updates/g' bumblebee.conf
  
  service bumblebeed start
  
  apt-get install git
  cd /tmp/
  git clone https://github.com/Bumblebee-Project/bumblebee-ui.git
  cd bumblebee-ui
  ./INSTALL
   
else
  echo "not a driver"
fi
