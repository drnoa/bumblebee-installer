#!/bin/bash
# This script will help you install nvidia drivers and bumblebee

echo "Type the nvidia driver Version you like to install. [ENTER] example: nvidia-355"

read nvididriver

if ($nvididriver); then
  apt-get remove --purge nvidia*
  sudo apt-get remove --purge bumblebee*
  apt-get --purge remove xserver-xorg-video-nouveau
  apt-get install linux-source && sudo apt-get install linux-headers-$(uname -r)
  
  echo "Backup the blacklist.conf to blacklist.conf.bak"
  cp /etc/modprobe.d/blacklist.conf /etc/modprobe.d/blacklist.conf.bak
  echo "add the nvidia drivers to the blacklist"
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
  
  apt-get update && apt-get dist-upgrade -y
  apt-get install $nvididriver-updates nvidia-settings
  
  apt-get remove --purge nvidia-prime
  
  apt-get install bumblebee bumblebee-nvidia virtualgl virtualgl-libs virtualgl-libs-ia32:i386 virtualgl-libs:i386
  sudo usermod -a -G bumblebee $USER
  
  
  cd /etc/bumblebee
  ls -Al
  
  sed -i 's/nvidia-current/$nvididriver-updates/g' bumblebee.conf
  
  sudo service bumblebeed start
   
else
  echo "not a driver"
fi

