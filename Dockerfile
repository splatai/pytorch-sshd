FROM condaforge/mambaforge:latest

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        curl openssh-server mosh sudo vim wget ssh net-tools dnsutils git && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd \
    && echo 'AuthorizedKeysFile %h/.ssh/authorized_keys' >> /etc/ssh/sshd_config \
    && echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config \
    && echo 'ChallengeResponseAuthentication no' >> /etc/ssh/sshd_config \
    && echo 'UsePAM yes' >> /etc/ssh/sshd_config \
    && echo 'AllowTcpForwarding yes' >> /etc/ssh/sshd_config

RUN mamba install -y pytorch torchvision torchaudio cudatoolkit=11.6 -c pytorch -c conda-forge

COPY setup-keys.sh /bin/
WORKDIR /workspace

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD setup-keys.sh