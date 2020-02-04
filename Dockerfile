FROM kalilinux/kali-linux-docker:latest
MAINTAINER  Heitor Gouvêa hi@heitorgouvea.me

EXPOSE 1337 3306 8080

RUN apt -qy update
RUN apt list --upgradable
RUN apt -qy dist-upgrade

RUN apt install -qy \
	gcc \
  	wget \
  	curl \
  	git \
	python3 \
  	python-pip \
  	man \
  	unzip \
  	nmap \
  	wpscan \
  	sqlmap \
  	john \
  	radare2 \
  	apktool \
  	exploitdb \
  	weevely \
  	fcrackzip \
  	metasploit-framework \
  	hashid \
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
	mycli \
	dirb \
	testssl.sh \
	tcpdump \
	libwww-perl \
	libdbd-mysql-perl \
  	&& apt clean \
  	&& apt -y autoremove \
  	&& rm -rf /var/lib/apt/lists/*

RUN gunzip /usr/share/wordlists/rockyou.txt.gz
RUN pip install httplib2
RUN export PATH=$PATH:~/go/bin/
RUN gem install aquatone
RUN cpan Switch Switch IO::Socket::SSL LWP::UserAgent LWP::Protocol::https HTTP::Request LWP::Protocol::https JSON Mojolicious::Lite Config::Simple WWW::Mechanize re::engine::TRE DBIx::Custom File::Which