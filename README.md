# Freefeed Feeder

Feeder is a content sharing service for [freefeed.net](https://freefeed.net), an open source social network. Feeder can monitor RSS, ATOM, Reddit, Twitter, YouTube, or potentially any other web feed updates, normalize the content and share clean and readable excerpts on FreeFeed. Check out https://freefeed.net/xkcd for example.

![](https://raw.githubusercontent.com/dreikanter/feeder/master/screenshots/feeds-index.png)

## Development

Build docker image:

    docker-compose build

Run Rails server:

    docker-compose up app

Run test suite:

    docker-compose run test

Open bash console:

    docker-compose run sh

See [project wiki](https://github.com/dreikanter/feeder/wiki) for more details.

# CLI

Feeder-specific Rake commads:

    $ rails -T | grep feeder

    rails feeder:pull                                 # Pull one specific feed: "rake feeder:pull[feed_name]"
    rails feeder:pull_all                             # Pull all feeds
    rails feeder:pull_stale                           # Pull stale feeds
    rails feeder:subs                                 # Update Freefeed subscriptions count
    rails feeder:clean                                # Clean old data points
    rails feeder:import_nitter_instances              # Import public Nitter instances list

## Communication

If you have a question or want to report a bug, please open an issue.

## References

- Production instance (service status page): https://frf.im
- Ansible playbooks for deployment and server provisioning: https://github.com/dreikanter/feeder-ansible
- Project wiki: https://github.com/dreikanter/feeder/wiki
