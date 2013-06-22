shopt -s extglob

export SRC_HOME="/Users/zo/vsco"

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
alias mac='vi $SRC_HOME/machines.txt'
alias please='sudo'
alias be='bundle exec'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ,,='..'
alias ,,,='...'
alias ,,,,='....'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias S='ssh'
alias s3='s3cmd'
alias downd='cp ~/Dropbox/dotfiles/.bashrc ~/.'
alias upd='cp ~/.bashrc ~/Dropbox/dotfiles/.; . ~/.bashrc'
alias tl='tail -f'

# dirs
alias c='cd  $SRC_HOME/chef'
alias m='cd  $SRC_HOME/chef/cookbooks/mongodb'
alias s='cd  $SRC_HOME/camstore'
alias a='cd  $SRC_HOME/android'
alias b='cd  $SRC_HOME/zo-mrbilldroid'
alias v='cd  $SRC_HOME/chef/cookbooks/vsco/recipes'
alias e='cd  $SRC_HOME/chef/environments'
alias r='cd  $SRC_HOME/chef/roles'
alias ro='cd $SRC_HOME/rose'
alias vs='cd $SRC_HOME/vsco'
alias cu='cd $SRC_HOME/vsco/bin/curator'
alias t='cd  $SRC_HOME/themes'

# android
alias unpush='adb uninstall com.vsco.cam'
alias push='(a && cd VSCOCam && echo "                             `date`" && ls -al *apk && adb uninstall com.vsco.cam; adb install VSCOCam.apk; adb shell am start -a android.intent.action.MAIN -n com.vsco.cam/.SplashActivity)'
alias logcat='adb logcat > /tmp/logcat.txt &'
alias logvsco='tail -f /tmp/logcat.txt | grep VSCO'
alias logall='tail -f /tmp/logcat.txt'
alias adb-restart='adb kill-server; adb start-server'
alias apk='find . -name \*.apk'
alias rapk='find . -name \*.apk | xargs rm -rf'
# export GRADLE_OPTS="-Dorg.gradle.daemon=true" 

alias curlw='curl -w "@$HOME/.curl_format"'

function b64 {
	echo
	echo "$1" | base64 -D
	echo 
}

alias rssblogd='curlw -v -s -o /dev/null http://vscodev.com/rss/blog'
alias rssblog='curlw -v -s -o /dev/null http://vsco.co/rss/blog'
alias rssblogx='curlw -v -s -o x http://vsco.co/rss/blog'

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
function pl {
	p lb-peta$1
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

function geo {
    curl -s http://freegeoip.net/json/$1 | python -mjson.tool 
}

function ha-geo {
	scp zo@prod-lb-peta0:/tmp/xray_404.log ~/.
	cat ~/xray_404.log | awk '{print $1}' > xray.ip
	echo "Non-Unique IPs: `wc -l xray.ip`"
	cat xray.ip | sort | uniq > xray2
	mv xray2 xray.ip
	echo "Unique IPs: `wc -l xray.ip`"
	rm xray.geo
	for i in `cat xray.ip`;do geoiplookup $i >> xray.geo; done

	rm xray.analysis
	array=( "United States" "Canada" "Mexico" "Australia" "Malaysia" "Hong Kong" "Japan" "Address not found" "India" "Taiwan" "Korea" "Vietnam" "China" "Indonesia" "Philippines" "New Zealand" "Fiji" "Lao People" "South Africa" "Morocco" "France" "Romania" "Poland" "Spain" "Italy" "United Kingdom" "Belgium" "Russian Federation" "Slovenia" "Norway" "Greece" "Israel" "Germany" "Sweden" "Ireland" "Brazil" "Qatar" "Denmark" "Iran" "Austria" "Switzerland" "Turkey" "Kuwait" "Thailand" "Singapore" "Guam" "Bahamas" "Saudi Arabia" "Serbia" "Finland" "Ukraine" "Bulgaria" "Albania" "Macau" "Pakistan" "Brunei" "Venezuela" "Colombia" "Estonia" "Hungary" "Dominican Republic" "Guatemala" "Sudan" "United Arab Emirates" "Portugal" "Chile" "Peru" "Argentina" "Azerbaijan" "Bahrain" "Czech Republic" "Cyprus" "Curacao" "Ecuador" "Egypt" "Croatia" "Kenya" "Jordan" "Cambodia" "Kazakhstan" "Lebanon" "Netherlands" "Puerto Rico" "Slovakia" "Uganda" "Mongolia" "Belarus" "Bangladesh" "Gibraltar" "Honduras" "Costa Rica" "Uruguay" "Iceland" "Bolivia" "Lithuania" "Luxembourg" "Latvia" "Jamaica" "Malta" "Nigeria" "Panama" "Paraguay" "Uruguay")
	for i in "${array[@]}"; do
		echo "`grep \"$i\" xray.geo | wc -l`: $i" >> xray.analysis
		grep -v "$i" xray.geo > xray.temp
		mv xray.temp xray.geo
	done

	cat xray.analysis | sort -r > xray.analysis.sorted
	rm xray.analysis
	cat xray.geo | sort | uniq > xray.geo.missed
	"Not counting: `cat xray.geo.missed`"
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
# export OPENSSL_HOME=/usr/local/ssl/
export NPM_RELATIVE="./node_modules/.bin"
export PHP_HOME=$(brew --prefix josegonzalez/php/php54)
export GROOVY_HOME=/usr/local/opt/groovy/libexec

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

function init-cam {
  if [ "$1" = "" ]; then
    echo
    echo " init-cam <name>"
    echo
    echo "Ex: init-cam prod-xray2"
	echo
	return
  fi

  name=$1
  env="prod"
  [[ $name = "dev"* ]] && env="dev"

  # deploy camstore
  echo 
  echo "DEPLOYING CAMSTORE to $env"
  echo
  cd $SRC_HOME/camstore
  git checkout master
  git pull
  tag=`git tag | grep prod- | sort -n | tail -1`
  cap fu $env=$name from_tag="$tag"

  # deploy xrays
  echo 
  echo "DEPLOYING XRAYS to $env"
  echo
  cd $SRC_HOME/xrays
  git checkout master
  git pull
  cap fu force=$name

}


function init-app {
  if [ "$1" = "" ]; then
    echo
    echo " init-app <name>"
    echo
    echo "Ex: init-app prod-app2"
	echo
	return
  fi

  name=$1
  env="prod"
  [[ $name = "dev"* ]] && env="dev"

  echo
  echo "RUNNING CHEF"
  echo

  # FIRST, COPY THE ID_RSA to ~/vsco/.ssh/id_rsa on the box
  echo 
  echo "UPLOADING SSH KEY"
  echo
  cd $SRC_HOME/vsco
  cas upload_ssh $env=$name
  cap stop       $env=$name

  # first, stop chef
  # cap chef_stop prod=all

  # now, run chef on everything but the load balancers
  # so iptables to mongo/mysql/gearmand/etc is all whitelisted
  # cap chef prod=cam,mongo,mysql,gearman,star,varnish,edge

  # deploy assets
  echo 
  echo "DEPLOYING ASSETS to $env"
  echo
  cd $SRC_HOME/assets
  git checkout master
  git pull
  cap fu $env=$name

  # deploy themes
  echo 
  echo "DEPLOYING THEMES to $env"
  echo
  cd $SRC_HOME/themes
  git checkout master
  git pull
  tag=`git tag | grep prod- | sort -n | tail -1`
  cap fu $env=$name from_tag="$tag"

  # deploy app
  echo 
  echo "DEPLOYING APP to $env"
  echo
  cd $SRC_HOME/vsco
  git checkout master
  git pull
  tag=`git tag | grep prod- | sort -n | tail -1`
  cap fu force=$name from_tag="$tag"

  # now run chef on the load balancers so they find the new app box
}





function rs-create {
  if [ "$1" = "" ]; then
	echo
    echo " Rackspace Pricing: http://www.rackspace.com/cloud/servers/pricing"
	echo
    echo " > knife rackspace flavor list"
    echo "       ID  Name                     VCPUs  RAM    Disk"
    echo "       2   512MB Standard Instance  1      512    20 GB"
    echo "       3   1GB Standard Instance    1      1024   40 GB"
    echo "       4   2GB Standard Instance    2      2048   80 GB    <- app/cam prod"
    echo "       5   4GB Standard Instance    2      4096   160 GB"
    echo "       6   8GB Standard Instance    4      8192   320 GB   <- giga lb"
    echo "       7   15GB Standard Instance   6      15360  620 GB   <- tera lb"
    echo "       8   30GB Standard Instance   8      30720  1200 GB  <- peta lb"
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
  	if [ "$1" = "" ]; then
    	echo
    	echo " rs-delete <name>"
    	echo
    	echo "Ex: rs-delete dev-xray9"
		echo
		return
  	fi

	c

  	id=`knife rackspace server list | grep "$1 " | awk '{print $1}'`
  	time knife rackspace server delete $id -P

  	dns-delete $1			vsco.co
  	dns-delete $1-private	vsco.co
    # knife client delete $1

  	cd -
}

set -o vi
