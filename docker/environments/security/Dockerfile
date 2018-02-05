# Dockerfile to start up Kali Linux environment with most useful tools leaving bloat off
FROM kalilinux/kali-linux-docker
MAINTAINER d47zm3 <d47zm3@gmail.com>
# for oh-my-zsh
ENV TERM screen 

RUN cd ~

RUN apt-get update
RUN apt-get -y upgrade
# hacking tools
RUN apt-get -y install nmap nikto dirb pdf-parser exiftool steghide volatility metasploit-framework netcat netdiscover unicornscan
# common tools
RUN apt-get -y install git curl wget zip tmux zsh
# fetch dotfiles
RUN wget --no-check-certificate https://raw.githubusercontent.com/d47zm3/dotfiles/master/.tmux.conf
RUN wget --no-check-certificate https://raw.githubusercontent.com/d47zm3/dotfiles/master/.vimrc
# set shell to zsh
RUN chsh -s /bin/zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
ADD ./motd /etc/motd
ADD ./minimal.theme /root/.oh-my-zsh/themes/minimal.zsh-theme
ADD ./.zshrc /root/.zshrc
