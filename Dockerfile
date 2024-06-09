FROM perl:5.32-threaded

COPY . /usr/src/spellbook
WORKDIR /usr/src/spellbook

RUN apt-get update && \
    apt-get install -y masscan

RUN cpanm --installdeps .

ENTRYPOINT [ "perl", "./spellbook.pl" ]