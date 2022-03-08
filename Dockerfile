FROM ruby:3

RUN apt-get update --yes \
  && apt-get install --yes --no-install-recommends \
    apt-utils \
    build-essential \
  && gem install bundler:'~> 2.3' \
  && rm -rf /var/lib/apt/lists/* \
  && alias l="ls -al"

ARG RAILS_ENV
ARG DATABASE_URL
ARG REDIS_URL

ENV RAILS_ENV=$RAILS_ENV
ENV RACK_ENV=$RAILS_ENV
ENV DATABASE_URL=$DATABASE_URL
ENV REDIS_URL=$REDIS_URL

# Make sure Rails bin stubs are available on the path
ENV PATH ./bin:$PATH

WORKDIR /app
