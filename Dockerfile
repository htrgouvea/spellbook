FROM kalilinux/kali-linux-docker:latest
MAINTAINER  Heitor Gouvêa hi@heitorgouvea.me

RUN apt -qy update
RUN apt list --upgradable
RUN apt -qy dist-upgrade
RUN apt -qy install

RUN apt install -qy \
  wget \
  curl \
  git \
  man \
  unzip \
  nmap \
  wpscan \
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
  sublist3r \
  whois \
  smtp-user-enum \
  zsh \
  hydra \
  netcat \
  fping \
  && apt clean \
  && apt -y autoremove \
  && rm -rf /var/lib/apt/lists/*

RUN curl -L https://cpanmin.us | perl - --sudo App::cpanminus
RUN gem install aquatone
RUN cpanm LWP::UserAgent JSON MIME::Base32 Text::Morse WWW::Mechanize

RUN git clone https://github.com/codingo/Interlace && cd Interlace && python3 setup.py install

EXPOSE 1337
