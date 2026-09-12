FROM perl:5.44-slim

WORKDIR /usr/src/spellbook
COPY . .

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpcap-dev \
    masscan \
    libexpat1-dev \
    libssl-dev \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

RUN cpanm --notest --installdeps .

ENTRYPOINT ["perl", "./spellbook.pl"]
