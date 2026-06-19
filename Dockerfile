FROM perl:5.40-slim

WORKDIR /usr/src/spellbook
COPY . .

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpcap-dev \
    masscan \
    libexpat1-dev \
 && rm -rf /var/lib/apt/lists/*

RUN cpanm --notest --installdeps .

ENTRYPOINT ["perl", "./spellbook.pl"]
