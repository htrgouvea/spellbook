FROM kalilinux/kali-linux-docker:latest
MAINTAINER  Heitor Gouvêa hi@heitorgouvea.me

RUN apt -qy update
RUN apt list --upgradable
RUN apt -qy dist-upgrade

RUN apt install -qy \
  gcc \
  wget \
  curl \
  git \
  man \
  unzip \
  nmap \
  wpscan \
  dirb \
  nikto \
  sqlmap \
  hashcat \
  john \
  findmyhash \
  radare2 \
  apktool \
  exploitdb \
  weevely \
  theharvester \
  gdb \
  fcrackzip \
  metasploit-framework \
  hashid \
  python-pip \
  smali \
  dex2jar \
  whois \
  smtp-user-enum \
  zsh \
  hydra \
  netcat \
  fping \
  golang \
  exiftool \
  steghide \
  binwalk \
  metagoofil \
  recon-ng \
  wordlists \
  libjson-perl \
  libwww-perl \
  libmime-base32-perl \
  nodejs \
  npm \
  netdiscover \
  && apt clean \
  && apt -y autoremove \
  && rm -rf /var/lib/apt/lists/*

RUN gunzip /usr/share/wordlists/rockyou.txt.gz
RUN pip install httplib2
RUN export PATH=$PATH:~/go/bin/
RUN git clone https://github.com/codingo/Interlace && cd Interlace && python3 setup.py install
RUN cpan install LWP::Protocol::https IO::Socket::SSL

EXPOSE 1337
