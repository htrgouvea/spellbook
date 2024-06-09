FROM perl:5.32-threaded

COPY . /usr/src/spellbook
WORKDIR /usr/src/spellbook

RUN cpanm --installdeps .

ENTRYPOINT [ "perl", "./spellbook.pl" ]