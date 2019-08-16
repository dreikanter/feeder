export POSTGRES_DB_NAME="feeder"

set -x

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

sudo update-locale LANGUAGE=$LANGUAGE LC_ALL=$LC_ALL LANG=$LANG LC_TYPE=$LC_TYPE

cd
sudo apt-get update --yes
sudo apt-get install --yes \
  git \
  curl \
  wget \
  htop \
  tree \
  zlib1g-dev\
  build-essential\
  libssl-dev\
  libreadline-dev\
  libyaml-dev\
  libxml2-dev\
  libxslt1-dev\
  libcurl4-openssl-dev\
  python-software-properties \
  software-properties-common \
  sqlite3 \
  libsqlite3-dev \
  ne \
  jq \
  2> /dev/null



echo "-----> install postgres"

sudo apt-get install --yes postgresql postgresql-contrib libpq-dev

sudo bash -c "cat > /etc/postgresql/10.0/main/pg_hba.conf" <<EOL
local all all trust
host all all 127.0.0.1/32 trust
host all all ::1/128 trust
EOL

sudo service postgresql restart



echo "-----> create postgres database"

createdb "$POSTGRES_DB_NAME"_development --username=postgres
createdb "$POSTGRES_DB_NAME"_test --username=postgres
createdb "$POSTGRES_DB_NAME"_production --username=postgres



echo "-----> install nodejs"

cd
sudo curl --silent --show-error -L https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get update
sudo apt-get install --yes nodejs



echo "-----> install yarn"

sudo curl --silent --show-error https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install --yes yarn



echo "-----> install ruby"

cd
rm -rf ~/.rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
rm -rf ~/.rbenv/plugins/ruby-build
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rm -rf ~/.rbenv/plugins/rbenv-update
git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update

echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

# Increasing the amount of inotify watchers
# SEE: https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

rbenv install 2.6.3
rbenv global 2.6.3
rbenv rehash

sudo gem update --system
gem update
gem install bundler --no-rdoc --no-ri --force

# Fix FileUtils warnings
# SEE: https://github.com/ruby/fileutils/issues/22
gem uninstall fileutils
gem update fileutils --default

echo "-----> update .gemrc"

cat > ~/.gemrc <<EOL
---
gem: --no-ri --no-rdoc
benchmark: false
verbose: true
backtrace: true
EOL



echo "---> install ansible"

# Requires software-properties-common
sudo apt-add-repository --yes ppa:ansible/ansible
sudo apt-get update
sudo apt-get install --yes ansible



echo "---> update .bashrc"

cat >> ~/.bashrc <<EOL
cd /app
EOL



echo "-----> cleanup"

sudo apt autoremove --yes
sudo apt-get clean



echo "-----> report"

echo "ruby:          $(ruby --version)"
echo "gem:           $(gem --version) GEM_HOME: $GEM_HOME"
echo "bundler:       $(bundler --version)"
echo "yarn:          $(yarn --version)"
echo "node:          $(node --version)"
echo "psql:          $(psql --version)"
