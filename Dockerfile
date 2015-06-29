FROM ubuntu:14.04
#FROM debian:jessie
MAINTAINER Rachel Evans <github.com/rvedotrc>

RUN apt-get update
RUN apt-get install -y daemontools
RUN install -d /etc/service

CMD ["/usr/bin/svscanboot"]

RUN apt-get install -y nginx vim
COPY ./ /usr/local/website-proxy

WORKDIR /usr/local/website-proxy

RUN rm -f /etc/nginx/sites-enabled/default \
  && ln -s $PWD/service/nginx/conf.d/*.conf /etc/nginx/conf.d/ \
  && ln -s $PWD/service/nginx/sites-available/* /etc/nginx/sites-available/ \
  && ln -s /etc/nginx/sites-available/sinatra /etc/nginx/sites-enabled/sinatra

RUN ln -s /usr/local/website2015/service/nginx /etc/service/nginx
RUN ln -s /usr/local/website2015/service/crond /etc/service/crond
RUN ln -s /usr/local/website2015/service/rsyslogd /etc/service/rsyslogd

EXPOSE 80
