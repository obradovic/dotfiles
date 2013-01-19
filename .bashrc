
set -o vi

# OPS shortcuts
alias cc='chef-client -l info'
alias ccd='chef-client -l debug'
alias k='knife'
alias kr='knife rackspace'
alias krs='kr '
alias ke='knife ec2'
alias ks='knife status'
alias ck='knife cookbook'
alias up='knife cookbook upload'
alias upr='knife role from file'
alias upu='knife data bag from file users $1'
alias urp='upr'

alias downd='cp ~/Dropbox/dotfiles/.bashrc ~/.'
alias upd='cp ~/.bashrc ~/Dropbox/dotfiles/.; . ~/.bashrc'

# GIT'R DONE!
alias g='git'
alias gs='git submodule'
alias gd='git diff'
alias co='git checkout'
alias gp='git pull --rebase'
alias god='git'
alias st='git status'
alias add='git add'
alias com='git commit -m'
alias coma='git commit -am'
alias pu='git push'
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
alias mroe='more'
alias copy='cp'
alias move='mv'
alias c='cd ~/vsco/chef'
alias s='cd ~/vsco/vsco-cam-store'
alias a='cd ~/vsco/vsco-cam-2/AndroidLucy'
alias b='cd ~/vsco/zo-mrbilldroid'
alias v='cd ~/vsco/chef/cookbooks/vsco/recipes'

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
export NPM_HOME=/usr/local/share/npm/
export ANDROID_HOME=~/adt-bundle-mac/sdk
export HEROKU_HOME=/usr/local/heroku
# export OPENSSL_HOME=/usr/local/ssl/

# Python
export PYTHONPATH=~/

export PATH=~/bin:$PATH
# export PATH=$OPENSSL_HOME/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$PATH:$NPM_HOME/bin
export PATH=$PATH:$HOME/.rvm/bin 
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HEROKU_HOME/bin
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
export PS1='\[\e[1;30m\]\T\[\e[0m\] \[\e[0;32m\]`hostname`\[\e[0m\]\[\e[0;35m\]$(__git_ps1 " (%s)")\[\e[0m\] \[\e[0;32m\]\W  > \[\e[0m\]'
# export PS1='\[\e[1;30m\]\T\[\e[0m\] \[\e[1;30m\]`parse_git_branch`\[\e[0m\] \[\e[1;32m\]\W  > \[\e[0m\]'
# export PS1="\[$BBlack\]\T `parse_git_branch` \[$Color_Off\]\[$BGreen\]\W  > \[$Color_Off\]"

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
alias dev1='ssh zo@dev1.visualsupply.co'
alias uploader='ssh -v -i ~/.ssh/mwukey.pem ec2-user@107.20.197.62'
alias mongo3='ssh -v -i ~/.ssh/mwukey.pem ubuntu@107.20.241.49'
alias dev-store='ssh zo@dev-store.visualsupply.co'
alias dev2='ssh dev-cheese'

function rs-create {
  if [ "$1" = "" ]; then
	echo
    echo "Usage: <name> <env> <run_list> <size>"
	echo
    echo "       <name>     the name of this node"
    echo "       <env>      defaults to \"dev\""
    echo "       <run_list> defaults to \"'role[standalone]'\" (needs single quotes)"
    echo "       <size>     defaults to \"2\""
	echo
    echo "       Example:   rs-create loader dev 'role[lb]'"
	echo
    return
  fi
  name=$1

  if [ "$2" = "" ]; then
    env="dev"
  else
    env=$2
  fi

  if [ "$3" = "" ]; then
    run_list=\'role[standalone]\'
  else
    run_list=$3
  fi

  if [ "$4" = "" ]; then
    flavor="2"
  else
    flavor='$4'
  fi

  fullname=$env-$name
  echo "Creating $fullname with a run_list of $run_list, size $flavor"

  image="8a3a9f96-b997-46fd-b7a8-a9e740796ffd"
  # endpoint="https://ord.servers.api.rackspacecloud.com/v2"
  endpoint="https://dfw.servers.api.rackspacecloud.com/v2"
  # json='{ "attributes": { "env": "dev", "run_list": [ "role[standalone]" ] } }'

  cd ~/vsco/chef

  knife rackspace server create -VV --image $image --flavor $flavor --server-name $fullname --node-name $fullname -r $run_list --environment $env -d ubuntu12-ruby1.9.1 --rackspace-endpoint $endpoint --run-list $run_list

  # cmd="knife rackspace server create --image $image --flavor $flavor --server-name $fullname --node-name $fullname --run-list $run_list --rackspace-endpoint $endpoint --environment dev --json-attributes '$json'"
  # # cmd="knife rackspace server create --image $image --flavor $flavor --server-name $fullname --node-name $fullname --run-list \"$run_list\" --environment $env --rackspace-endpoint $endpoint"
  # echo $cmd
  # $cmd
  knife node set_environment $fullname $env
  # knife node run_list add $fullname $run_list
}


function dns-delete {
  	dns_id=`dnsimple record:list visualsupply.co | grep "$1.visualsupply.co (A)" | awk '{print $5}' | cut -f 2 -d ":" | cut -f 1 -d ")"`

  	if [ -z "$dns_id" ]; then
    	echo "DNS record is empty for $1. Not deleting."
  	else
    	echo "Deleting DNS record $dns_id"
    	dnsimple record:delete visualsupply.co $dns_id
  	fi
}

function rs-delete {
	c

  	id=`knife rackspace server list | grep $1 | awk '{print $1}'`
  	knife rackspace server delete $id -P

  	dns-delete $1	
  	dns-delete $1-private

  	cd -
}

