# Request for contributions

Please contribute to this repository if you want to:

- Add a new feed.
- Help with one of the [open issues](https://github.com/dreikanter/feeder/issues).
- Fix or improve project documentation or UI text.

# How to contribute

Prerequisites:

- Knowledge of [Ruby on Rails](https://rubyonrails.org/) framework.
- Knowledge of [Markdown](https://help.github.com/articles/markdown-basics/) for editing `.md` documents.
- Familiarity with [pull requests](https://help.github.com/articles/using-pull-requests) and [issues](https://guides.github.com/features/issues/).

# Communication

GitHub issues are the primary way for communicating about specific proposed
changes to this project.

## Contribution

Here are some tips if you like to add a new feed or feature:

- Create a personal fork of the project on Github.
- Clone the fork on your local machine. Your remote repo on Github is called `origin`.
- Add the original repository as a remote called `upstream` (`git remote add upstream https://github.com/dreikanter/feeder.git`).
- If you created your fork a while ago be sure to pull upstream changes into your local repository (`git checkout master && git pull --rebase upstream master`).
- Branch from the `master`.
- Implement your feature or fix a bug. Comment your code.
- Write or adapt tests as needed.
- Follow the code style of the project.
- Push your branch to your fork on Github, the remote origin.
- From your fork open a pull request in the correct branch. Target the `master` branch.
- Once the pull request is approved and merged you can pull the changes from upstream to your local repo and delete your extra branch(es).
