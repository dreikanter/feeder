# Freefeed Feeder

Copy `.env.example` to `.env` with a real Freefeed auth token, and run it like so:

    bundle
    bundle exec ruby bin/xkcd

Or using crontab:

    0 0,12 * * * cd ~/freefeed-feeder && ~/.rbenv/shims/bundle exec ruby bin/xkcd > ~/freefeed-feeder/log/cron.log 2>&1
