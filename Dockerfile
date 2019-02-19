FROM ubuntu:18.04

# Removes DBUS warning that should be only seen by Developer
# https://bugs.launchpad.net/ubuntu/+source/at-spi2-core/+bug/1193236
ENV NO_AT_BRIDGE=1

# Will not prompt for questions
ARG DEBIAN_FRONTEND=noninteractive

ARG HOST_USER="${HOST_USER:-devuser}"
ARG HOST_UID="${HOST_UID:-2000}"
ARG HOST_GID="${HOST_GID:-2000}"
ARG SUBLIME_BUILD="${SUBLIME_BUILD:-3126}"

## preesed tzdata, update package index, upgrade packages and install needed software
RUN echo "tzdata tzdata/Areas select Europe" > /tmp/preseed.txt; \
    echo "tzdata tzdata/Zones/Europe select Lisbon" >> /tmp/preseed.txt; \
    debconf-set-selections /tmp/preseed.txt && \
    rm -rf /etc/timezone && \
    rm -rf /etc/localtime

# basics needed
RUN apt-get update && apt-get install -y --fix-missing \
  tzdata \
  wget \
  software-properties-common \
  git \
  cmake \
  python-dev \
  ack-grep \
  curl \
  tmux \
  apt-transport-https \
  ca-certificates \
  apt-utils \
  dbus-x11 \
  libcanberra-gtk-module \
  libgtk2.0-0 \
  libatk-adaptor \
  libgail-common && \

  # Force Install of missing dependencies
  apt-get -y -f install

# set before so that the update does it all once
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN curl -sL https://deb.nodesource.com/setup_10.x | /bin/bash -
RUN curl -sL https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
RUN echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list

RUN apt-get update

# for vim
RUN apt-get install -y --fix-missing \
  python-pip \
  python3-dev \
  python3-pip \
  vim \
  vim-nox \
  neovim

# for sublime
# RUN curl -O https://download.sublimetext.com/sublime-text_build-"${SUBLIME_BUILD}"_amd64.deb && \
#   dpkg -i -R sublime-text_build-"${SUBLIME_BUILD}"_amd64.deb || echo "\n Will force install of missing ST3 dependencies...\n" && \
#   apt-get -y -f install && \
#   rm -rvf sublime-text_build-"${SUBLIME_BUILD}"_amd64.deb
RUN apt-get install -y sublime-text

# for node
RUN apt-get install -y --fix-missing nodejs && \
  npm install -g stylelint eslint typescript

# for golang
RUN rm -rf go1* && \
  curl -O https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz && \
  tar xvf go1*.tar.gz && \
  rm -rf /usr/local/go && \
  mv go /usr/local && \
  rm -rf go1*

# add the dev user now
RUN useradd -ms /bin/bash ${HOST_USER}
USER ${HOST_USER}
WORKDIR /home/${HOST_USER}

COPY ./template/.config /home/${HOST_USER}/.config
COPY ./template/.gitconfig /home/${HOST_USER}/.gitconfig
COPY ./template/.gitignore_global /home/${HOST_USER}/.gitignore_global
COPY ./template/.tmux.conf /home/${HOST_USER}/.tmux.conf
COPY ./template/.userrc /home/${HOST_USER}/.userrc

# set the .userrc on the bash
RUN echo "" >> /home/${HOST_USER}/.bashrc && \
  echo "# Custom code" >> /home/${HOST_USER}/.bashrc && \
  echo "if [ -f /home/${HOST_USER}/.userrc ]; then" >> /home/${HOST_USER}/.bashrc && \
  echo "  . /home/${HOST_USER}/.userrc;" >> /home/${HOST_USER}/.bashrc && \
  echo "fi" >> /home/${HOST_USER}/.bashrc;

# ENV LANG en_GB.UTF-8
# ENV LANGUAGE en_GB:en
# ENV LC_ALL en_GB.UTF-8
ENV SHELL /bin/bash

# set the work folder
RUN mkdir -p /home/${HOST_USER}/work

# set some alias for easier access
RUN echo "" >> /home/${HOST_USER}/.userrc && \
  echo "# Alias" >> /home/${HOST_USER}/.userrc && \
  echo "alias sublime_x='/usr/bin/subl -w --sync ~/work'" >> /home/${HOST_USER}/.userrc
