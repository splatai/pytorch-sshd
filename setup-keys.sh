#!/bin/bash
echo "Setting up keys"
mkdir -p $HOME/.ssh
chmod 700 $HOME/.ssh

authorized_keys=$HOME/.ssh/authorized_keys
touch $authorized_keys
chmod 600 $authorized_keys

touch $authorized_keys
for user in $GITHUB_USERS; do
  echo "Getting ${user}'s public key from GitHub"
  curl -s "https://github.com/${user}.keys" >> $authorized_keys
done
echo "" >> $authorized_keys

echo "keys setup, starting sshd"
/usr/sbin/sshd -D
echo "ssh running"