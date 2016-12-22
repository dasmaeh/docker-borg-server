# docker container running borg in server mode

FROM debian:stretch
MAINTAINER Jan Köster <dasmaeh@cbjck.de>

# set needed variables

# install ssh and borg
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    openssh-server \
    borgbackup

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add user borg and create home directory
RUN useradd borg && \
    mkdir /home/borg && \
    mkdir /home/borg/.ssh && \
    touch /home/borg/.ssh/authorized_keys && \
    chown -R borg:borg /home/borg

# Create privilege separation directory: /var/run/sshd
RUN mkdir /var/run/sshd

# Copy sshd_config
RUN rm /etc/ssh/sshd_config
COPY sshd_config /etc/ssh/sshd_config

# Copy start.sh
COPY start.sh /usr/local/sbin/start.sh
RUN chmod +x /usr/local/sbin/start.sh


# Expose port 22 for ssh access
EXPOSE 22

# Expose volumes
VOLUME [ "/home/borg" ]
VOLUME [ "/home/borg/repos" ]

# Command:
CMD ["/usr/local/sbin/start.sh" ]

# TODO: Create a start.sh to fix directory permissions before starting sshd
# chown borg:users /home/borg
# chown -R borg:users /home/borg/.ssh
# chmod 700 /home/borg/.ssh
# chmod 600 /home/borg/.ssh/authorized_keys
# chown -R borg:users /home/borg/repos
