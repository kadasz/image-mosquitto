FROM phusion/baseimage:latest
MAINTAINER Karol D Sz

ENV APP mosquitto
ENV APP_PORT 1883
ENV APP_USER mosquitto
ENV APP_HOME /etc/mosquitto

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "deb http://ppa.launchpad.net/mosquitto-dev/mosquitto-ppa/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/$APP.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 77B7346A59027B33C10CAFE35E64E954262C4500
RUN apt-get update && apt-get -q -y --no-install-recommends install $APP

RUN apt-get clean
RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN mkdir -p /etc/service/$APP
COPY $APP.run /etc/service/$APP/run
RUN chmod +x /etc/service/$APP/run

RUN chown -R $APP_USER:$APP_USER $APP_HOME

WORKDIR $APP_HOME
EXPOSE $APP_PORT
CMD ["/sbin/my_init"]
