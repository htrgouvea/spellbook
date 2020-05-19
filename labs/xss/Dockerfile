FROM debian:latest
MAINTAINER Heitor Gouvêa <hi@heitorgouvea.me>

EXPOSE 8080

COPY . /usr/src/xss
WORKDIR /usr/src/xss

RUN apt -qy update \
    && apt list --upgradable \
    && apt -qy upgrade \
    && apt install -qy curl \
                      make \
                      gcc \
                      perl \
    && apt clean \
  	&& apt -y autoremove


RUN cpan install re::engine::TRE Mojolicious::Lite

CMD ["perl", "application.pl", "daemon", "-m", "production", "-l", "http://*:8001"]