FROM debian:latest
MAINTAINER Heitor Gouvêa <hi@heitorgouvea.me>

EXPOSE 8003

COPY . /usr/src/blind-ssrf
WORKDIR /usr/src/blind-ssrf

RUN apt -qy update \
    && apt list --upgradable \
    && apt -qy upgrade \
    && apt install -qy curl \
                      make \
                      gcc \
                      perl \
    && apt clean \
  	&& apt -y autoremove


RUN cpan install Mojolicious::Lite

CMD ["perl", "application.pl", "daemon", "-m", "production", "-l", "http://*:8003"]