FROM ruby:2

RUN apt-get update --yes \
  && apt-get install --yes --no-install-recommends \
    apt-utils \
    build-essential \
  && gem install bundler:'~> 2.3' \
  && rm -rf /var/lib/apt/lists/*

ARG RAILS_ENV
ARG DATABASE_URL

ENV RAILS_ENV=$RAILS_ENV
ENV RACK_ENV=$RAILS_ENV
ENV DATABASE_URL=$DATABASE_URL

WORKDIR /app
