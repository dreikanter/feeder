# Freefeed Feeder

Copy `.env.example` to `.env` with a real Freefeed auth token.

Background jobs:

    rails jobs:work

Refresh all feeds:

    rails pull:all

Crontab:

    0 * * * * cd ~/freefeed-feeder && ~/.rbenv/shims/bundle exec rails pull:all > ~/freefeed-feeder/log/cron.log 2>&1

DB migration during Heroku deployment:

    heroku run --app freefeed-feeder rails db:migrate
