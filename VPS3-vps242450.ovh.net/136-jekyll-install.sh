#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=jekyll-install
config_default_install=no
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# install ruby
# https://www.howtoforge.com/tutorial/installing-ruby-on-rails-on-ubuntu-1404/

_re "apt-get install -y curl git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev" "Ruby env installed" "Ruby env installation failed"
#_re "cd /tmp/ && curl -#LO https://rvm.io/mpapis.asc && gpg --import mpapis.asc && curl -sSL https://get.rvm.io | bash -s stable" "RVM installer ok" "RVM installer failed"
#_re "source /etc/profile.d/rvm.sh && rvm requirements" "RVM env set" "RVM env set failed"
#_re "rvm install 2.2.0" "Ruby 2.2.0 installed" "Ruby 2.2.0 installation failed"
#_re "gem install rubygems-update; update_rubygems; gem update --system" "Rubygems updated" "Rubygems update failed"

# https://andrewvora.com/2015/11/03/setting-up-jekyll-ubuntu-gh-pages.html
_re "cd ~/ && git clone git://github.com/sstephenson/rbenv.git .rbenv" "rbenv cloned" "rbenv clone failed"
_re "echo 'export PATH="$HOME/.rbenv/bin:$PATH" >> ~/.bashrc && echo 'eval "$(rbenv init -)"' >> ~/.bashrc && git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build && echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc" "rbenv ok" "rbenv nok"
_re "rbenv install -v 2.2.3 && rbenv global 2.2.3 && gem install bundler" "Ruby 2.2.3 installed" "Ruby 2.2.3 installation failed"
_re "gem install jekyll" "Jekyll installed" "Jekyll installation failed"
_re "gem update jekyll" "Jekyll updated" "Jekyll update failed"

# ruby --version

