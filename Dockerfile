FROM perl:5.38

COPY . /usr/src/spellbook
WORKDIR /usr/src/spellbook

RUN cpanm --installdeps .

ENTRYPOINT [ "perl", "./spellbook.pl" ]