## personal devops notes

I intend to collect here all informations about DevOps related things 

### shell customization

This is my goto daily setup, working on MacOS.

- vim (personal .vimrc without bloat found in dotfiles)
- zsh ([oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) with some enabled plugins and personal theme)
- tmux (personal config found in dotfiles)

### package manager - brew

Currently used packages
```
brew install vault
brew install vim
brew install kops
brew install kubernetes-helm
brew install wget
brew install git
brew install kubectx
brew install htop
brew install jq
brew install telnet
brew install tnftp tnftpd telnet telnetd
brew install npm
brew install watch
brew install awscli
brew install coreutils
brew install gpg
brew install p7zip
brew install mysql
brew install stern
brew install go
brew install ntfs-3g
brew install tree
brew install ansible
brew install ansifilter
brew install terraform
brew install gnu-sed
brew install kubectl
brew cask install osxfuse
brew cask install minikube
```

### kubernetes - local tools

- stern
- kubectx / kubens

### kubernetes - useful addons

- nginx-ingress - this is must to handle incoming requests for ingress resources
- grafana/prometheus/alertmanager - monitoring/alerting
- elasticsearch/fluentbit or fluentd/kibana - aggregating logs
- elastic-curator - to clean up log indices from elasticsearch
- cert-manager - get TLS certificate for your ingress from Let's Encrypt for free
- kube-slack - get notified on various fail events in your cluster
- kubewatch - track state change on your pods/deployments etc.
