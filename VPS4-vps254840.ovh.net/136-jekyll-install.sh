#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=jekyll-install
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# install ruby
_re "apt-get install -y curl git-core build-essential zlib1g-dev libssl-dev libreadline6-dev gem libyaml-dev ruby ruby-dev" "Ruby installed" "Ruby installation failed"
_re "gem install rubygems-update; update_rubygems; gem update --system" "Rubygems updated" "Rubygems update failed"
_re "gem install jekyll" "Jekyll installed" "Jekyll installation failed"
_re "gem update jekyll" "Jekyll updated" "Jekyll update failed"
