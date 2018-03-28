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

Refresh all feeds every 5 minutes:

```
*/5 * * * * cd /var/www/feeder/current && RAILS_ENV=staging /home/deploy/.rbenv/shims/bundle exec rails pull:all jobs:workoff > /var/www/feeder/current/log/cron.log 2>&1
```

Run Rake task on Heroku instance:

```
heroku run --app freefeed-feeder rails pull:all
```

Watch the log:

```
heroku logs --app freefeed-feeder --tail
```

## How to add new feed

- Add new feed to `config/feeds.yml`
- Create private group on https://candy.freefeed.net
- Create private group on https://freefeed.net
- Update group description and avatar
- Create or reuse processor class
- Create or reuse normalizer class
- Test new feed processing on candy.
- Test on production.
- Open public access for the new group.

Testing new feed:

``` ruby
name = 'the-atlantic-photos'
feed = Feed.for(name)
entities = Service::FeedLoader.load(name)
normalizer = Service::FeedNormalizer.for(feed)
entities.map { |e| normalizer.process(e[1]) }
```
