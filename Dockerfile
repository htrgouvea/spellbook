FROM kalilinux/kali-linux-docker:latest
MAINTAINER  Heitor Gouvêa hi@heitorgouvea.me

EXPOSE 1337

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
  	fcrackzip \
  	metasploit-framework \
  	hashid \
  	python-pip \
  	smali \
  	dex2jar \
  	whois \
  	hydra \
  	netcat \
  	fping \
  	golang \
  	exiftool \
  	steghide \
  	binwalk \
  	wordlists \
  	nodejs \
  	npm \
  	netdiscover \
	mycli \
  	&& apt clean \
  	&& apt -y autoremove \
  	&& rm -rf /var/lib/apt/lists/*

RUN gunzip /usr/share/wordlists/rockyou.txt.gz

RUN pip install httplib2
RUN export PATH=$PATH:~/go/bin/
RUN git clone https://github.com/codingo/Interlace interlace && cd interlace && python3 setup.py install

RUN gem install rest-client json net-ping