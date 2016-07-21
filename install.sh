#!/usr/bin/bash

#########################################################
# Horus developed by Heitor Gouvea                      #
# This work is licensed under MIT License               #
# Copyright (c) 2016 Heitor Gouvea                      #
#                                                       #
# [+] AUTOR:        Heitor Gouvea                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

if [ -e /etc/pacman.conf ]
then
	sudo pacman -S perl --needed
elif [ -e /etc/apt ]
then
	sudo apt-get install perl
elif [ -e /etc/yum.conf ]
then
	sudo yum install perl perl-CPAN
else
	echo "Your system is unsupported by this script"
	echo "Please install the dependencies manually"
	echo "open the terminal and type: sudo cpan install Switch"
fi
sudo cpan install Switch

if [ -e /usr/share/horus ]
then
	sudo rm -rf /usr/share/horus
fi

if [ -e /usr/bin/horus ]
then
	sudo rm /usr/bin/horus
fi

cd .. && sudo mv horus /usr/share/

sudo sh -c 'echo "#!/bin/bash" > /usr/bin/horus'
sudo sh -c 'echo "cd /usr/share/horus" >> /usr/bin/horus'
sudo sh -c 'echo "exec perl horus.pl $@" >> /usr/bin/horus'
sudo chmod +x /usr/bin/horus
clear
horus
