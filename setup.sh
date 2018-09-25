#!/usr/bin/bash

export BLUE='\033[1;94m'
export GREEN='\033[1;92m'
export RED='\033[1;91m'
export ENDC='\033[1;00m'

if [ $(id -u) -ne 0 ]; then
    echo -e "\n$RED[!] This script must be run as root$ENDC\n" >&2
    exit 1
fi

function installDependencies() {
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
        echo "Install the [
          MIME::Base32 MIME::Base64 Text::Morse Net::Ping IO::Socket::INET JSON LWP::UserAgent Net::Ping Net::DNS IO::Select IO::Socket::Timeout WWW::Mechanize
        ] modules"
    fi

    cpan install MIME::Base32 MIME::Base64 Text::Morse Net::Ping IO::Socket::INET JSON LWP::UserAgent Net::Ping Net::DNS IO::Select IO::Socket::Timeout  WWW::Mechanize
}

installDependencies
