# Freefeed Feeder

Feeder is a content sharing service for [freefeed.net](https://freefeed.net), an open source social network.

Feeder can monitor RSS, ATOM, Reddit, Twitter, YouTube, and other web feed updates, normalize the content and share clean and readable excerpts on FreeFeed.

Check out https://freefeed.net/xkcd for example.

![](https://raw.githubusercontent.com/dreikanter/feeder/master/screenshots/feeds-index.png)

## Development

**Development environment setup:**

Build Docker containers and run Rails server:

```sh
docker-compose build
docker-compose up app
```

Install or update packages:

```sh
docker-compose run app bundle install
docker-compose run app bundle update
```

Shell:

```sh
docker-compose run sh
```

Rake tasks (`rails -T | grep feeder`):

```sh
rails feeder:pull                     # Pull one specific feed: "rake feeder:pull[feed_name]"
rails feeder:pull_all                 # Pull all feeds
rails feeder:pull_stale               # Pull stale feeds
rails feeder:subs                     # Update Freefeed subscriptions count
rails feeder:clean                    # Clean old data points
rails feeder:import_nitter_instances  # Import public Nitter instances list
```

## Deployment

How it works:

- `master` is the integration branch.
- `release` is the release branch.
- Head revision of the `release` branch is on production.
- Merge `master` to `release` immediately before the deployment.
- `./bin/release_master` script pushes head from `master` to `release`.

Ansible playbooks for deployment and server provisioning:

- https://github.com/dreikanter/feeder-ansible

## Communication

If you have a question or want to report a bug, please open an issue.

## References

- Status page: https://frf.im
- Project wiki: https://github.com/dreikanter/feeder/wiki
- Service account on Freefeed: https://freefeed.net/feeder
