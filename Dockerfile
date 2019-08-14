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
	mariadb-server
  	&& apt clean \
  	&& apt -y autoremove \
  	&& rm -rf /var/lib/apt/lists/*

RUN mysqld_safe
RUN mysql -uroot -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin'"
RUN mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION"
RUN gunzip /usr/share/wordlists/rockyou.txt.gz
RUN pip install httplib2
RUN export PATH=$PATH:~/go/bin/
RUN git clone https://github.com/codingo/Interlace interlace && cd interlace && python3 setup.py install
RUN cpan install LWP::Protocol::https IO::Socket::SSL DBIx::Custom Switch Config::Simple JSON LWP::UserAgent MIME::Base32 Text::Morse IO::Socket::Timeout Net::DNS WWW::Mechanize

EXPOSE 1337 3306
