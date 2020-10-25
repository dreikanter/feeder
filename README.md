# Freefeed Feeder

Feeder is a content sharing service built for [freefeed.net](https://freefeed.net), an open source social network. Feeder can monitor RSS, ATOM, Reddit, Twitter, YouTube, Tumblr, or potentially any other web feed updates, normalize the content and share clean and readable excerpts on FreeFeed. Check out https://freefeed.net/xkcd for example.

![](https://raw.githubusercontent.com/dreikanter/feeder/master/screenshots/feeds-index.png)

## References

- Production instance (service status page): https://frf.im
- Ansible playbooks for deployment and server provisioning: https://github.com/dreikanter/feeder-ansible
- Project wiki: https://github.com/dreikanter/feeder/wiki

## Development

Vagrant setup:

    vagrant up
    vagrant ssh

Running Rails server:

    bundle install
    bundle exec rails server

Running Webpack dev server:

    yarn install
    ./bin/webpack-dev-server

Running tests:

    bundle exec rails test

### Docker setup

Build docker image:

    docker-compose build

Install dependensies:

    docker-compose run runner bin/setup

Start feeder web app:

    docker-compose up app

Start dev environment bash console:

    docker-compose run runner bash

## Scheduling

Schedule feeds updates:

    */5 * * * * cd /var/www/feeder/current && RAILS_ENV=production /home/deploy/.rbenv/shims/bundle exec rails feeder:pull_stale jobs:workoff

Schedule Freefeed stats update:

    0 * * * * cd /var/www/feeder/current && RAILS_ENV=production /home/deploy/.rbenv/shims/bundle exec rails feeder:subs jobs:workoff

## Communication

If you have any questions or want to report a bug, please open an issue.
