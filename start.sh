#!/bin/bash

# Fix directory permissions
chown borg:users /home/borg
chown -R borg:users /home/borg/.ssh
chmod 700 /home/borg/.ssh
chmod 600 /home/borg/.ssh/authorized_keys
chown -R borg:users /home/borg/repos

# Start ssh daemon
/usr/sbin/sshd -D -f /etc/ssh/sshd_config -E /var/log/sshd.log
