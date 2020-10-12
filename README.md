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

Docker setup:

- Build docker image
 ```sh
    $ docker-compose build
 ```
- Start feeder service
 ```sh
    $ ./docker/start-service.sh -s
 ```
 _Note: If you are facing 'Permission denied' error when executing the above command, then re-run the command after granting executable permissions to the 'start-service.sh' file_
   ```sh
      $ chmod +x ./docker/start-service.sh
   ```

- Stop feeder service
 ```sh
    $ ./docker/start-service.sh -k
 ```
- _Note: Check out start-service shell script 'help' command for more details_
 ```sh
     $ ./docker/start-service.sh -h
 ```

Chrome extensions:

- [React dev tools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en)
- [Redux dev tools](https://chrome.google.com/webstore/detail/redux-devtools/lmhkpmbekcpmknklioeibfkpmmfibljd?hl=en)

## Scheduling

Schedule feeds updates:

```
*/5 * * * * cd /var/www/feeder/current && RAILS_ENV=production /home/deploy/.rbenv/shims/bundle exec rails pull:all jobs:workoff > /var/www/feeder/current/log/cron-pull.log 2>&1
```

Schedule Freefeed stats update:

```
0 * * * * cd /var/www/feeder/current && RAILS_ENV=production /home/deploy/.rbenv/shims/bundle exec rails subs jobs:workoff > /var/www/feeder/current/log/cron-subs.log 2>&1
```

## Contribution

Feeder is open for contributions! Here are some tips if you like to add a new feed or feature:

- Create a personal fork of the project on Github.
- Clone the fork on your local machine. Your remote repo on Github is called origin.
- Add the original repository as a remote called upstream.
- If you created your fork a while ago be sure to pull upstream changes into your local repository.
- Branch from the `dev`.
- Implement your feature or fix a bug. Comment your code.
- Write or adapt tests as needed.
- Follow the code style of the project.
- Push your branch to your fork on Github, the remote origin.
- From your fork open a pull request in the correct branch. Target the `dev` branch.
- Once the pull request is approved and merged you can pull the changes from upstream to your local repo and delete your extra branch(es).

If you have any questions or want to report a bug, please open an issue or send me a message on alex.musayev@gmail.com
