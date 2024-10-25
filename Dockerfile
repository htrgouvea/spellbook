FROM perl:5.40-threaded

COPY . /usr/src/spellbook
WORKDIR /usr/src/spellbook

RUN apt-get update && \
    apt-get install -y libpcap-dev masscan

RUN cpanm --installdeps .

ENTRYPOINT [ "perl", "./spellbook.pl" ]