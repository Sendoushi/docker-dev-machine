FROM ubuntu:18.04

## preesed tzdata, update package index, upgrade packages and install needed software
RUN echo "tzdata tzdata/Areas select Europe" > /tmp/preseed.txt; \
    echo "tzdata tzdata/Zones/Europe select Lisbon" >> /tmp/preseed.txt; \
    debconf-set-selections /tmp/preseed.txt && \
    rm -rf /etc/timezone && \
    rm -rf /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata

# basics needed
RUN apt-get install -y --fix-missing wget software-properties-common git cmake python-dev ack-grep curl tmux apt-transport-https

# set before so that the update does it all once
RUN add-apt-repository ppa:neovim-ppa/unstable
# RUN wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
RUN curl -sL https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_10.x | /bin/bash -

RUN apt-get update

# for vim
RUN apt-get install -y --fix-missing python-pip python3-dev python3-pip vim vim-nox neovim

# for sublime
# RUN echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
# RUN apt-get install -y --fix-missing sublime-text

# for node
RUN apt-get install -y --fix-missing nodejs;
RUN npm install -g stylelint eslint typescript

# for golang
RUN rm -rf go1*;
RUN curl -O https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz;
RUN tar xvf go1*.tar.gz;
RUN rm -rf /usr/local/go;
RUN mv go /usr/local;
RUN rm -rf go1*;

# add the dev user now
RUN useradd -ms /bin/bash devuser
USER devuser
WORKDIR /home/devuser

COPY ./template/.config /home/devuser/.config
COPY ./template/.gitconfig /home/devuser/.gitconfig
COPY ./template/.gitignore_global /home/devuser/.gitignore_global
COPY ./template/.tmux.conf /home/devuser/.tmux.conf
COPY ./template/.userrc /home/devuser/.userrc

# set the .userrc on the bash
RUN echo "" >> /home/devuser/.bashrc;
RUN echo "# Custom code" >> /home/devuser/.bashrc;
RUN echo "if [ -f /home/devuser/.userrc ]; then" >> /home/devuser/.bashrc;
RUN echo "  . /home/devuser/.userrc;" >> /home/devuser/.bashrc;
RUN echo "fi" >> /home/devuser/.bashrc;

# set the work folder
RUN mkdir -p /home/devuser/work
