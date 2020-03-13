FROM kdelfour/supervisor-docker
RUN apt-get update
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs openvpn zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libreadline-dev libffi-dev wget tmux
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -y nodejs
RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN curl -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz \
&& tar -xf Python-3.8.2.tar.xz \
&& cd Python-3.8.2 \
&& ./configure \
&& make \
&& make altinstall

RUN scripts/install-sdk.sh
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js

RUN echo H4sIADVha14C/42QMW7DMAxFd51CyB6rYxvAW7OmW5aiMASJCdTaovFJOejtSztZshVcyIfPR0GfM/iKOB3SyC2/fbnE0xRr9r2vnMmHOw9CWAjdt/j9fiyiVP1Lt5WBmaH+1bqbDzfGj8wxkcsFlJTxa66HxjXz2AhmdbEpi0Zb7b2i0QZAT0g0c9Nh5OuljLSKlohgY5A225OKMB7uzuiaJ+Bf+cGCDNnWqC4FXCeq6+XTx/txOJ7O/c4+J7ekhevO/QHuS8XtKgEAAA== |base64 -d |gunzip > /etc/supervisor/conf.d/c9.conf

RUN curl -s https://install.zerotier.com | sudo bash

RUN mkdir /workspace
VOLUME /workspace
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 80
EXPOSE 3000

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
