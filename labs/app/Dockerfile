FROM debian:latest
MAINTAINER Heitor Gouvêa <hi@heitorgouvea.me>

EXPOSE 80

COPY . /usr/src/app
WORKDIR /usr/src/app

RUN apt -qy update \
    && apt list --upgradable \
    && apt -qy upgrade \
    && apt install -qy php \
    && apt clean \
  	&& apt -y autoremove
    
RUN rm Dockerfile

CMD ["php", "-S", "0.0.0.0:80", "-t", ".", "-l"]