FROM kalilinux/kali-rolling:latest
MAINTAINER  Heitor Gouvêa <hi@heitorgouvea.me>

WORKDIR /home/
EXPOSE 1337 9090

RUN apt -qy update
RUN apt list --upgradable
RUN apt -qy dist-upgrade

RUN apt install -qy \
	python3 \
  	python3-pip \
  	man \
  	unzip \
  	wpscan \
  	sqlmap \
  	john \
	amass \
  	radare2 \
  	apktool \
  	exploitdb \
  	weevely \
  	fcrackzip \
  	metasploit-framework \
  	hashid \
  	jadx \
  	hydra \
  	netcat \
  	fping \
  	exiftool \
  	steghide \
  	binwalk \
  	wordlists \
	# mycli \
	golang \
	# dirb \
	tree \
	testssl.sh \
	libwww-perl \
	libdbd-mysql-perl \
  	&& apt clean \
  	&& apt -y autoremove \
  	&& rm -rf /var/lib/apt/lists/*

RUN gunzip /usr/share/wordlists/rockyou.txt.gz
RUN pip3 install httplib2 mmh3 requests
RUN cpan Switch IO::Socket::SSL LWP::UserAgent LWP::Protocol::https HTTP::Request JSON Mojolicious::Lite Config::Simple WWW::Mechanize re::engine::TRE DBIx::Custom
RUN cpan install Email::MIME Email::Sender::Simple Email::Sender::Transport::SMTP
