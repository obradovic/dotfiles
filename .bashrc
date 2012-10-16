
set -o vi

# Machines
alias db1='ssh zo@prod-db1.visualsupply.co'
alias db2='ssh zo@prod-db2.visualsupply.co'
alias db3='ssh zo@prod-db3.visualsupply.co'
alias fe1='ssh zo@prod-fe1.visualsupply.co'
alias fe2='ssh zo@prod-fe2.visualsupply.co'
alias fe3='ssh zo@prod-fe3.visualsupply.co'
alias mongo1='ssh zo@prod-mongod1.visualsupply.co'
alias mongo2='ssh zo@prod-mongod2.visualsupply.co'
alias cron1='ssh zo@prod-cron1.visualsupply.co'
alias dmongo='ssh zo@198.101.240.202'
alias drepo='ssh zo@dev-repo1.visualsupply.co'
alias dev1='ssh zo@dev1.visualsupply.co'
alias staging='ssh zo@50.56.207.198'

# OPS shortcuts
alias cc='chef-client -l info'
alias ccd='chef-client -l debug'
alias k='knife'
alias ks='knife status'
alias ck='knife cookbook'
alias up='knife cookbook upload'
alias upr='knife role from file'
alias urp='upr'

alias downd='cp ~/Dropbox/dotfiles/.bashrc ~/.'
alias upd='cp ~/.bashrc ~/Dropbox/dotfiles/.; . ~/.bashrc'

# GIT'R DONE!
alias g='git'
alias gs='git submodule'
alias co='git checkout'
alias gp='git pull --rebase'
alias god='git'
alias st='git status'
alias master='git checkout master'
alias masterc='for i in `ls -p cookbooks | grep "/"`; do cd cookbooks/$i; master; cd ../..; done'

alias dir='ls -la'
alias dor='dir'
alias dri='dir'
alias l='ls -al'
alias h='history 100'
alias j='jobs'
alias 1='fg %1'
alias 2='fg %2'
alias 3='fg %3'
alias 4='fg %4'
alias del='rm'
alias vig='mvim'
alias be='bundle exec'
alias r='rake'

alias dev1='ssh zo@dev1.visualsupply.co'

function pz {
  ps -aef | grep -i $1 | grep -v grep
}

function title {
  echo -e "\033];$1\007" 
  echo "Title set to $1"
}
alias tit=title

function dot {
  cd ~/.dotfiles
  git add .
  git commit -m $1
  git push
  . ~/.bashrc
  cd -
}

function dot-link {
  cd ~
  for f in .bashrc .vimrc .gvimrc
  do 
    mv -f $f $f.old
    ln -s .dotfiles/$f $f
  done
}

# OpsCode / Chef
export OPSCODE_USER=zo

# RVM
source ~/.rvm/scripts/rvm

# some default locations
export NGINX_HOME=/usr/local/Cellar/nginx/current
export APACHE_HOME=/usr/local/apache2

# Python
export PYTHONPATH=~/

export PATH=/usr/local/bin:$PATH
export PATH=~/bin:$PATH
export PATH=$PATH:$HOME/.rvm/bin 
export PATH=$PATH:.

# Prompt, and other bash goodies
export CLICOLOR=1
export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTFILE=~/.history_bash
export EDITOR=vi

# function parse_git_branch {
  # ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  # echo "("${ref#refs/heads/}")"
# }

export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUPSTREAM="auto"

. ~/.git-prompt.sh
. ~/.git-completion.sh
. ~/.colors_bash
export PS1='`hostname` \[\e[1;30m\]\T\[\e[0m\]\[\e[0;35m\]$(__git_ps1 " (%s)")\[\e[0m\] \[\e[0;32m\]\W  > \[\e[0m\]'
# export PS1='\[\e[1;30m\]\T\[\e[0m\] \[\e[1;30m\]`parse_git_branch`\[\e[0m\] \[\e[1;32m\]\W  > \[\e[0m\]'
# export PS1="\[$BBlack\]\T `parse_git_branch` \[$Color_Off\]\[$BGreen\]\W  > \[$Color_Off\]"

