# Freefeed Feeder

Local set up:

1. Copy `.env.example` to `.env`, with real env var values.

Heroku deployment:

1. Required resources: Heroku Postgres, Heroku Scheduler.
2. Ensure env vars from `.env.example` are set.
3. Migrate DB: `heroku run --app freefeed-feeder rails db:migrate`
4. Schedule `rails pull:all` task.

Running background jobs:

    rails jobs:work

Running web frontend:

    rails server

Schedule background jobs to refresh all feeds:

    rails pull:all

Refresh all feeds every hour:

    0 * * * * cd ~/freefeed-feeder && ~/.rbenv/shims/bundle exec rails pull:all > ~/freefeed-feeder/log/cron.log 2>&1

Run Rake task on Heroku instance:

    heroku run --app freefeed-feeder rails pull:all

Watch the log:

    heroku logs --app freefeed-feeder --tail
