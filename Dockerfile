FROM kalilinux/kali-linux-docker:latest
MAINTAINER GouveaHeitor

EXPOSE 1337 
VOLUME /Users/$(whoami)/Documents/kali-linux-docker

RUN apt update && apt list --upgradable && apt -y dist-upgrade && apt install -y \
  wget \
  curl \
  git \
  man \
  unzip \
  nmap \
  dirb \
  wpscan \
  gobuster \
  nikto \
  sqlmap \
  hashcat \
  john \
  findmyhash \
  radare2 \
  apktool \
  exploitdb \
  weevely \
  fierce \
  dnsenum \
  dnsmap \
  dnsrecon \
  theharvester \
  gdb \
  fcrackzip \
  metasploit-framework \
  hashid \
  python-pip \
  openvpn \
  && apt clean \
  && apt -y autoremove \
  && rm -rf /var/lib/apt/lists/*
