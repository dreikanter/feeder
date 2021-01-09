FROM ruby:2.6.5

RUN curl https://deb.nodesource.com/setup_12.x | bash \
  && curl --location https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update --yes \
  && apt-get install --yes --no-install-recommends apt-utils build-essential yarn \
  && gem install bundler:'~> 2.1.4' \
  && rm -rf /var/lib/apt/lists/*

ARG RACK_ENV
ARG RAILS_ENV
ARG DATABASE_URL

ENV RAILS_ENV=$RAILS_ENV
ENV RACK_ENV=$RACK_ENV
ENV DATABASE_URL=$DATABASE_URL

WORKDIR /app
