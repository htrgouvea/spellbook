#!/usr/bin/perl

#########################################################
# Horus developed by Heitor Gouvêa                      #
# This work is licensed under MIT License               #
# Copyright (c) 2017 Heitor Gouvêa                      #
#                                                       #
# [+] AUTOR:        Heitor Gouvêa                       #
# [+] EMAIL:        hgouvea@protonmail.com              #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

my $red = "\033[1;91m";
my $end = "\033[1;00m";

if (`id -u` != "0") {
	print "$red\n[!] This script must be run as root $end\n";
	exit;
}


if (`-e /etc/perl/Net/libnet.cfg`) {
	system ("cpan install Switch JSON LWP::UserAgent");
}

else {
	print "
	\n$red
	\r[!] Your system is unsupported by this script
	\rPlease install the dependencies manually
	\ropen the terminal and type: sudo cpan install Switch JSON LWP::UserAgent $end
	\n";
}

if (`-e /usr/share/horus`) {
	system ("rm -rf -e /usr/share/horus");
}

if (`-e /usr/bin/horus`) {
	system ("rm -rf /usr/bin/horus");
}

system ("cd .. && sudo mv horus /usr/share/");

# sudo sh -c 'echo "#!/bin/bash" > /usr/bin/horus'
# sudo sh -c 'echo "cd /usr/share/horus" >> /usr/bin/horus'
# sudo sh -c 'echo "exec perl horus $@" >> /usr/bin/horus'

system ("sudo chmod +x /usr/bin/horus");
system ("clear && horus");
