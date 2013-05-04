set -o vi
shopt -s extglob


# OPS shortcuts
alias cc='chef-client -l info'
alias ccd='chef-client -l debug'
alias k='knife'
alias kr='knife rackspace'
alias krs='kr server'
alias krsl='krs list'
alias ke='knife ec2'
alias ks='knife status'
alias ck='knife cookbook'
alias up='knife cookbook upload'
alias upr='knife role from file'
alias upe='knife environment from file'
alias upu='knife data bag from file users $1'
alias kshow='knife node show'
alias kedit='knife node edit'
alias urp='upr'

# GIT'R DONE!
alias g='git'
alias gs='git submodule'
alias gd='git diff'
alias ga='git add'
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

# generic
alias dir='ls -la'
alias dor='dir'
alias dri='dir'
alias dur='dir'
alias h='history 100'
alias j='jobs'
alias 1='fg %1'
alias 2='fg %2'
alias 3='fg %3'
alias 4='fg %4'
alias del='rm'
alias vig='mvim'
alias vo='vi'
alias vu='vi'
alias mroe='more'
alias copy='cp'
alias move='mv'
alias bas='vi ~/.bashrc && . ~/.bashrc'
alias mac='vi ~/vsco/machines.txt'
alias please='sudo'
alias be='bundle exec'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias S='ssh'
alias s3='s3cmd'
alias downd='cp ~/Dropbox/dotfiles/.bashrc ~/.'
alias upd='cp ~/.bashrc ~/Dropbox/dotfiles/.; . ~/.bashrc'

# dirs
alias c='cd ~/vsco/chef'
alias m='cd ~/vsco/chef/cookbooks/mongodb'
alias s='cd ~/vsco/camstore'
alias a='cd ~/vsco/android/'
alias b='cd ~/vsco/zo-mrbilldroid'
alias v='cd ~/vsco/chef/cookbooks/vsco/recipes'
alias e='cd ~/vsco/chef/environments'
alias r='cd ~/vsco/chef/roles'
alias ro='cd ~/vsco/rose'
alias vs='cd ~/vsco/vsco'
alias cu='cd ~/vsco/vsco/bin/curator'

# android
alias unpush='adb uninstall com.vsco.cam'
alias push='(a && echo "                             `date`" && ls -al *apk && adb uninstall com.vsco.cam; adb install VSCOCam.apk; adb shell am start -a android.intent.action.MAIN -n com.vsco.cam/.SplashActivity)'
alias logcat='adb logcat > /tmp/logcat.txt &'
alias logvsco='tail -f /tmp/logcat.txt | grep VSCO'
alias logall='tail -f /tmp/logcat.txt'
alias adb-restart='adb kill-server; adb start-server'


function ksearch {
	knife search node "roles:$1"
}


function l {
	LOGDIR="/var/log"
	case "$1" in
	"aperr")	file="`ls -tr $LOGDIR/apache2/error* | tail -1`" ;;
	a*)			file="`ls -tr $LOGDIR/apache2/access* | tail -1`" ;;
	r*)			file="$LOGDIR/resizer.log" ;;
	g*)			file="$LOGDIR/gearmand.log" ;;
	m*)			file="$LOGDIR/mongodb/mongodb.log" ;;
	t*)			file="$LOGDIR/tracelyzer/tracelyzer.log" ;;
	*) 			echo "default" ;;
	esac

	tail -50f $file
}

function p {
	ssh prod-$1
}
function d {
	ssh dev-$1
}
function pm {
	p mysql$1
}
function pa {
	p app$1
}

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
export PEAR_HOME=/Users/zo/pear/
export PHP_HOME=/usr/local/opt/php54
# export OPENSSL_HOME=/usr/local/ssl/
export NPM_RELATIVE="./node_modules/.bin"

# Python
export PYTHONPATH=~/

export PATH=$PHP_HOME/bin:$PATH
export PATH=$PEAR_HOME/bin:$PATH
# export PATH=$OPENSSL_HOME/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$PATH:$NPM_HOME/bin
export PATH=$PATH:$HOME/.rvm/bin
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HEROKU_HOME/bin
export PATH=$PATH:.

export PATH=~/bin:$PATH
export PATH=$NPM_RELATIVE:$PATH

# Prompt, and other bash goodies
export CLICOLOR=1
export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTFILE=~/.history_bash
export HISTIGNORE="&:ls:[bf]g:exit:[ \t]*"
export EDITOR=vi


if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

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
alias uploader='ssh -v -i ~/.ssh/mwukey.pem ec2-user@107.20.197.62'

function rs-create {
  if [ "$1" = "" ]; then
	echo
    echo " Rackspace Pricing: http://www.rackspace.com/cloud/servers/pricing"
	echo
    echo " > knife rackspace flavor list"
    echo "       ID  Name                     VCPUs  RAM    Disk"
    echo "       2   512MB Standard Instance  1      512    20 GB"
    echo "       3   1GB Standard Instance    1      1024   40 GB"
    echo "       4   2GB Standard Instance    2      2048   80 GB"
    echo "       5   4GB Standard Instance    2      4096   160 GB"
    echo "       6   8GB Standard Instance    4      8192   320 GB"
    echo "       7   15GB Standard Instance   6      15360  620 GB"
    echo "       8   30GB Standard Instance   8      30720  1200 GB"
    echo
    echo " rs-create <env> <name> <run_list> <flavor> <location>"
    echo
    echo "       <env>      "
    echo "       <name>     "
    echo "       <run_list> (needs single quotes)"
    echo "       <flavor>   defaults to \"2\" (512MB small)"
    echo "       <location> defaults to \"dfw\" (\"ord\" is a valid alternative)"
	echo

    echo "Ex: rs-create dev loader 'role[lb]'"
	echo
    return
  fi

  env=$1
  name=$2
  run_list="'$3'"

  if [ "$4" = "" ]; then
    flavor="2"
  else
    flavor=$4
  fi

  if [ "$5" = "" ]; then
    location="dfw"
  else
    location=$5
  fi

  image="8a3a9f96-b997-46fd-b7a8-a9e740796ffd" 
  endpoint="https://$location.servers.api.rackspacecloud.com/v2"
  fullname=$env-$name
  echo "Creating $fullname with a run_list of $run_list, flavor $flavor, in $location"
  # json='{ "attributes": { "env": "dev", "run_list": [ "role[standalone]" ] } }'

  c
  bootstrap="vsco-ubuntu"
  # bootstrap="internet"
  # time knife rackspace server create --image $image --flavor $flavor --server-name $fullname --node-name $fullname -r $run_list --environment $env -d $bootstrap --rackspace-endpoint $endpoint --run-list $run_list
  time knife rackspace server create -d $bootstrap --image $image --flavor $flavor --server-name $fullname --node-name $fullname --run-list $run_list --environment $env --rackspace-endpoint $endpoint 
  # knife node set_environment $fullname $env
}


function dns-update-ttl {
  	if [ "$1" = "" ]; then
		echo
		echo "dns-update-ttl <domain> <ttl>"
		echo
		echo "Example:"
		echo "dns-update-ttl vsco.co 600"
		echo "    sets TTL to 600 seconds (10 minutes)"
		echo
		return
	fi

	for record in `dnsimple record:list $1 | grep -v Found` 
	do
		if [[ $record == id* ]] ;
		then
			dnsimple record:update $1 `echo "${record%?}" | cut -f 2 -d ":"` ttl:$2
		fi
	done
}

function dns-delete {
	# dns-delete [machine name] [domain name]
  	dns_id=`dnsimple record:list $2 | grep "$1.$2 (A)" | awk '{print $5}' | cut -f 2 -d ":" | cut -f 1 -d ")"`

  	if [ -z "$dns_id" ]; then
    	echo "DNS record is empty for $1.$2. Not deleting."
  	else
    	echo "Deleting DNS record $dns_id for $1.$2"
    	dnsimple record:delete $2 $dns_id
  	fi
}

function rs-delete {
	c

  	id=`knife rackspace server list | grep "$1 " | awk '{print $1}'`
  	time knife rackspace server delete $id -P

  	dns-delete $1			vsco.co
  	dns-delete $1-private	vsco.co

  	cd -
}

