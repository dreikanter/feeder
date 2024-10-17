FROM ruby:3

RUN apt-get update --yes \
  && apt-get install --yes --no-install-recommends \
    apt-utils \
    build-essential \
    less \
    vim \
    curl \
  && gem install bundler:'~> 2.5' \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://bun.sh/install | bash

ENV PATH="/root/.bun/bin:${PATH}"

ARG RAILS_ENV
ARG DATABASE_URL

ENV RAILS_ENV=$RAILS_ENV
ENV RACK_ENV=$RAILS_ENV
ENV DATABASE_URL=$DATABASE_URL

EXPOSE 3000

WORKDIR /app
