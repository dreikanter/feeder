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

    0 * * * * cd /var/www/feeder && RAILS_ENV=production /home/deploy/.rbenv/shims/bundle exec rails pull:all > /var/www/feeder/log/cron.log 2>&1

Run Rake task on Heroku instance:

    heroku run --app freefeed-feeder rails pull:all

Watch the log:

    heroku logs --app freefeed-feeder --tail

## How to add new feed

- Add new feed to config/feeds.yml
- Create private group on candy.freefeed.net
- Create private group on freefeed.net
- Update group description and avatar
- Create or reuse processor class
- Create or reuse normalizer class
- Test new feed processing on candy.
- Test on production.
- Open public access for the new group.

Testing new feed:

``` ruby
feed_name = 'the-atlantic-photos'
feed = Feed.find_or_import(feed_name)
entity = Service::FeedLoader.load(feed_name).first[1]
Service::FeedNormalizer.for(feed).process(entity)
```
