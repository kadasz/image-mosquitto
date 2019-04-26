FROM phusion/baseimage:latest
MAINTAINER Karol D Sz

ENV TZ "${TZ:-Europe/Warsaw}"

ENV APP mosquitto
ENV APP_PORT 1883
ENV APP_USER mosquitto
ENV APP_HOME /etc/mosquitto
ENV APP_LOG_VOLUME /var/log/mosquitto
ENV APP_DATA_VOLUME /var/lib/mosquitto

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "deb http://archive.ubuntu.com/ubuntu bionic main universe" | tee -a /etc/apt/sources.list
RUN echo "deb http://ppa.launchpad.net/mosquitto-dev/mosquitto-ppa/ubuntu bionic main" | tee -a /etc/apt/sources.list.d/$APP.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 77B7346A59027B33C10CAFE35E64E954262C4500
RUN apt-get update && apt-get -q -y --no-install-recommends install $APP $APP-clients psmisc curl less vim wget net-tools lsof iproute2 tzdata

# cleanup
RUN apt-get autoremove -y; apt-get clean all
RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# add config and password file
COPY $APP.conf $APP_HOME
COPY passwd $APP_HOME

# disable cron service
RUN touch /etc/service/cron/down

# runit - prepare mosquitto service
RUN mkdir -p /etc/service/$APP
COPY $APP.run /etc/service/$APP/run
RUN chmod +x /etc/service/$APP/run

RUN chown -R $APP_USER:$APP_USER $APP_HOME

VOLUME ["$APP_HOME", "$APP_LOG_VOLUME", "$APP_DATA_VOLUME"]

WORKDIR $APP_HOME
EXPOSE $APP_PORT
CMD ["/sbin/my_init"]
