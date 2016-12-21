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

# Expose port 22 for ssh access
EXPOSE 22

# Expose volumes
VOLUME [ "/home/borg" ]
VOLUME [ "/home/borg/repos" ]

# Command:
CMD ["/usr/sbin/sshd", "-D"]
