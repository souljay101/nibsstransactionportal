FROM ruby:2.7.0-alpine

MAINTAINER Bolaji Aina <neoandey@yahoo.com>

ARG APP_PORT
ARG APP_NAME
ARG APP_REPO

ENV DEV_PACKAGES="build-base ruby-dev zlib-dev libxml2-dev libxslt-dev  binutils-gold build-base curl file g++ gcc git libstdc++ \
                  libffi-dev libc-dev linux-headers libxml2-dev libxslt-dev libgcrypt-dev  tzdata yaml-dev sqlite-dev git"\
    RAILS_PACKAGES="nodejs yarn"
WORKDIR /opt/rails/$APP_NAME
RUN  export http_proxy=http://172.16.11.34:8080 && export https_proxy=http://172.16.11.34:8080 && apk --update --upgrade add $RAILS_PACKAGES $DEV_PACKAGES \
     && apk add --no-cache --virtual .build-deps curl unzip --update npm \
     && mkdir -p  /opt/rails \
     && cd  /opt/rails \
     && git config --global http.proxy http://172.16.11.34:8080 \
     && git clone "${APP_REPO}" \
     && cd /opt/rails/$APP_NAME \

EXPOSE $APP_PORT
RUN export http_proxy=http://172.16.11.34:8080 && export https_proxy=http://172.16.11.34:8080 \
    && gem install bundler \
    && bundle config build.nokogiri --use-system-libraries \
    && bundle check || bundle install && yarn install --check-files
CMD bundle exec rails s -b 0.0.0.0 -p 3000
