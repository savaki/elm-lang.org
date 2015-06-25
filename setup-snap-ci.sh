#!/bin/sh

set -eux
  
cd /tmp
sudo yum install -y tar wget

# install the justhub-release rpm
#
wget http://sherkin.justhub.org/el6/RPMS/x86_64/justhub-release-2.0-4.0.el6.x86_64.rpm
rpm -ivh justhub-release-2.0-4.0.el6.x86_64.rpm

# install haskell
#
sudo yum install -y fedora-hub
sudo yum install -y haskell


