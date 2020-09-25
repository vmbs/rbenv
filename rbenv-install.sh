#!/bin/bash

# CentOS rbenv system wide installation script from rbenv official.

# Installs rbenv system wide on CentOS 7, also allows single user installs.

# Install pre-requirements
yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel \
  make bzip2 autoconf automake libtool bison iconv-devel git-core

# Check if Git is installed
hash git 2>&- || { 
  echo >&2 "Error: Git not found. Hint: Try installing the RPMForge or EPEL package repository.";
  exit 1;
}

# Check if /usr/local/rbenv already exists
if [[ -d "/usr/local/rbenv" ]]; then
  echo >&2  "Error: /usr/local/rbenv already exists. Aborting installation.";
  exit 1;
fi

# Install rbenv
git clone git://github.com/rbenv/rbenv.git /usr/local/rbenv

# Check if clone succesful
if [ $? -gt 0 ]; then
  echo >&2  "Error: Git clone error! See above.";
  exit 1;
fi

# Add rbenv to the path
echo '# rbenv setup - only add RBENV PATH variables if no single user install found' > /etc/profile.d/rbenv.sh
echo 'if [[ ! -d "${HOME}/.rbenv" ]]; then' >> /etc/profile.d/rbenv.sh
echo '  export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
echo '  export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
echo '  eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
echo 'fi'  >> /etc/profile.d/rbenv.sh

chmod +x /etc/profile.d/rbenv.sh

# Install ruby-build:
pushd /tmp
  rm -rf /tmp/ruby-build
  git clone git://github.com/rbenv/ruby-build

  # Check if clone succesful
  if [ $? -gt 0 ]; then
    echo >&2  "Error: Git clone error! See above.";
    exit 1;
  fi

  cd ruby-build
  ./install.sh
popd

echo '---------------------------------'
echo '    rbenv installed system wide to /usr/local/rbenv'
echo '    Remember to restart your shell for the changes to take effect!'
echo '---------------------------------'
