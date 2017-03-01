shopt -s extglob
set -o vi

export SRC_HOME="/Users/zo/phillies"
umask 0022

# PHIL
function phil-db {
	echo Password copied
	echo $PHIL_GCLOUD_DB_PW | pbcopy
	# gcloud beta sql connect $PHIL_GCLOUD_DB_INSTANCE -u $PHIL_GCLOUD_DB_USER
	mysql -h $PHIL_GCLOUD_DB_IP $PHIL_GCLOUD_DB_NAME -u $PHIL_GCLOUD_DB_USER -p
}
function phil-db-root {
	echo Password copied
	echo $PHIL_GCLOUD_DB_PW | pbcopy
	mysql -h $PHIL_GCLOUD_DB_IP $PHIL_GCLOUD_DB_NAME -u root -p
}
function admin {
	gcloud compute --project $PHIL_GCLOUD_PROJECT ssh --zone $PHIL_GCLOUD_ZONE admin
}
function g-create {
	knife google server create $1 \
	--gce-machine-type n1-standard-1 \
	--gce-image ubuntu-1604-lts \
	--ssh-user $CHEF_USERNAME \
	--identity-file ~/.ssh/id_rsa \
	--environment prod \
	--run-list 'role[base]'
}
function g-create-api {
	knife google server create $1 \
	--gce-machine-type n1-standard-1 \
	--gce-image ubuntu-1604-lts \
	--ssh-user $CHEF_USERNAME \
	--identity-file ~/.ssh/id_rsa \
	--environment prod \
	--run-list 'role[api]'
}
function g-create-lb {
	knife google server create $1 \
	--gce-machine-type n1-standard-1 \
	--gce-image ubuntu-1604-lts \
	--ssh-user $CHEF_USERNAME \
	--identity-file ~/.ssh/id_rsa \
	--environment prod \
	--run-list 'role[lb]'
}
function g-create-admin {
	# https://github.com/chef/knife-google
	knife google server create $1 \
		--gce-machine-type n1-standard-1 \
		--gce-boot-disk-size 500 \
		--gce-boot-disk-ssd true \
		--gce-image ubuntu-1604-lts \
		--gce-project $PHIL_GCLOUD_PROJECT \
		--gce-zone $PHIL_GCLOUD_ZONE \
		--ssh-user $CHEF_USERNAME \
		--identity-file ~/.ssh/id_rsa \
		--environment prod \
		--request-timeout 6000 \
		--auth-timeout 300 \
		--run-list 'role[admin]' 
}
function g-delete {
	knife google server delete --gce-project $PHIL_GCLOUD_PROJECT --gce-zone $PHIL_GCLOUD_ZONE $1
	kd $1
}
function g-ssh {
	gcloud compute ssh --project $PHIL_GCLOUD_PROJECT --zone $PHIL_GCLOUD_ZONE $1
}
function g-list {
	knife google server list --gce-project $PHIL_GCLOUD_PROJECT --gce-zone $PHIL_GCLOUD_ZONE
}
function s {
	. ~/.bashrc
	pushd .
	c
	local ip=`knife google server list  | grep $1 | tr -s ' ' | cut -d ' ' -f5`
	ssh $ip
	popd
}
function lsg {
	gsutil ls -lh gs://phil-backups/
}
function ls-backups {
	gsutil ls -lh gs://phil-backups/daily/phil_data/
}
function restore-latest-backup {

	gsutil cp `gsutil ls -lh gs://phil-backups/fullschema | grep daily | tail -1 | tr -s ' ' | cut -d' ' -f5` fullschema.sql.gz
	gzip -d fullschema.sql.gz
	mysql -uroot -e "DROP DATABASE phil_backup"
	mysql -uroot -e "CREATE DATABASE phil_backup"
	mysql -uroot -e "RESET MASTER"
	mysql -uroot < fullschema.sql

	gsutil cp `gsutil ls -lh gs://phil-backups/daily/phil_data/ | grep -v TOTAL | tail -1 | tr -s ' ' | cut -d' ' -f5` backup.sql.gz
	gzip -d backup.sql.gz
	pv backup.sql | mysql -uroot phil_backup
	rm backup.sql
}

export FLASK_APP=main.py
export FLASK_DEBUG=1

# GCLOUD
alias g='gcloud'
alias sshg='gcloud compute ssh'
alias gql='gcloud beta sql'
export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/legacy_credentials/$PHIL_GCLOUD_DB_USER_EMAIL/adc.json

# GO
export GOPATH=~/go

# CHEF shortcuts
alias cc='chef-client -l info'
alias ccd='chef-client -l debug'
alias k='knife'
alias kg='knife google'
alias ke='knife ec2'
alias kinst='knife cookbook site install'
alias kservers='knife google server list --gce-project $PHIL_GCLOUD_PROJECT --gce-zone $PHIL_GCLOUD_ZONE'
alias ks='knife status'
alias ck='knife cookbook'
alias up='knife cookbook upload'
alias upp='up phillies'
alias upr='knife role from file'
alias upe='knife environment from file'
alias upu='knife data bag from file users $1'
alias kshow='knife node show'
alias kedit='knife node edit'
alias urp='upr'
function ksearch {
	knife search node "roles:$1" 
}
function kd { 
	knife node delete -y $1
	knife client delete -y $1 
}


# VAGRANT
export VAGRANT_CWD=~/phillies/web           # Lets you run vagrant from any directory
export VAGRANT_DEFAULT_PROVIDER="vmware_fusion"
alias va='vagrant'
alias vs='vagrant ssh phillies-asparagus'
alias vup='va up phillies-asparagus'
alias vha='va halt phillies-asparagus'
alias vst='va status'


# GIT'R DONE!
alias gi='git'
alias god='git'
alias gs='git submodule'
alias gd='git diff'
alias gad='git add'
alias com='git commit -m'
alias st='git status'
alias co='git checkout'
alias gpl='git pull'
alias gpo='git pull origin'
alias gps='git push'
alias branch='co -b'
alias branchd='git branch -d'
alias stash='git stash'
alias stahs='stash'
alias sta='stash'
alias dev='co dev'
alias dev2='co dev2'
alias master='co master'
alias masterc='for i in `ls -p cookbooks | grep "/"`; do cd cookbooks/$i; master; cd ../..; done'

# ELASTICSEARCH
function curles {
    curl -s "localhost:9200/$1" | python -m json.tool
}

# generic
alias dir='ls -la'
alias dirw='ls -al | grep drw'
alias la='ls -la'
alias dor='dir'
alias dri='dir'
alias dur='dir'
# alias h='history 100'
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
alias bas='vi ~/.bashrc; sleep 0.5; . ~/.bashrc'
alias bass='vi ~/.bashrc_private; sleep 0.5; . ~/.bashrc'
alias please='sudo'
alias yolo='sudo !!'
alias be='bundle exec'
alias bcap='bundle exec cap'
alias dep='bundle exec cap prod deploy'
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
alias du1='du -h -d 1'
alias du2='du -h -d 2'
alias dfk='df -h -k'
alias S='ssh'
alias s3='aws s3'
alias downd='cp ~/Dropbox/dotfiles/.bashrc ~/.'
alias upd='cp ~/.bashrc ~/Dropbox/dotfiles/.; . ~/.bashrc'
alias tl='tail -f'
alias beep='for i in {1..3} ; do tput bel; sleep 1; done'
alias js='python -m json.tool'
alias us='underscore'
alias pt='papertrail'

function mcd {
	mkdir $1
	cd $1
}

function api {
	curl -s "$2" "https://api.phils.io/$1" | jq
}
function api-dev {
	curl -s "$2" "http://104.196.134.140/$1" | jq
}
function api-local {
	curl -s "$2" "http://localhost:5000/$1" | jq
}
function _api {
	curl -s $2 "$3/$1" 
}
function api-devo {
	curl -s $2 "104.196.134.140/$1"
}
function apio {
	curl -s $2 "api.phils.io/$1"
}
function api-localo {
	curl -s $2 "localhost:5000/$1" 
}

# dirs
alias p='cd  $SRC_HOME'
alias a='cd  $SRC_HOME/api/'
alias c='cd  $SRC_HOME/chef'
alias v='cd  $SRC_HOME/chef/cookbooks/phillies/recipes'
alias e='cd  $SRC_HOME/chef/environments'
alias r='cd  $SRC_HOME/chef/roles'

# android
alias pa='adb shell am start -a android.intent.action.MAIN -n com.vsco.cam/.SplashActivity'
alias m='(a; cd VSCOCam; gradlew assembleDebug; if [ $? -eq 0 ]; then pusha; else beep; fi)'
alias mn='(a; cd VSCOCam; gradlew assembleDebug) '
alias mr='(a; cd VSCOCam; gradlew assembleRelease; if [ $? -eq 0 ]; then pusha; else beep; fi)'
alias unpush='adb uninstall com.vsco.cam'
alias pusha='(a && cd VSCOCam && echo "                             `date`" && ls -la build/apk/VSCOCam-debug-unaligned.apk && adb uninstall com.vsco.cam; adb install build/apk/VSCOCam-debug-unaligned.apk; adb shell am start -a android.intent.action.MAIN -n com.vsco.cam/.SplashActivity)'
alias pushs='(a && cd VSCOCam && echo "                             `date`" && ls -la build/apk/VSCOCam-debug-unaligned.apk && adb uninstall com.vsco.cam; adb install build/apk/VSCOCam-debug-unaligned.apk; adb shell am start -a android.intent.action.MAIN -n com.vsco.cam/.billing.NativeStoreActivity)'
alias push='(a && cd VSCOCam && echo "                              `date`" && ls -al *apk && adb uninstall com.vsco.cam; adb install VSCOCam.apk; adb shell am start -a android.intent.action.MAIN -n com.vsco.cam/.SplashActivity)'
alias logcat='adb logcat > /tmp/logcat.txt &'
alias logvsco='tail -f /tmp/logcat.txt | grep -i VSCO'
alias logall='tail -f /tmp/logcat.txt'
alias adb-restart='adb kill-server; adb start-server'
alias apk='find . -name \*.apk | xargs ls -al'
alias rapk='find . -name \*.apk | xargs rm -rf'
# export GRADLE_OPTS="-Dorg.gradle.daemon=true" 


# loader
function loader {
	curl -s -H "loaderio-auth: $LOADERIO_KEY" https://api.loader.io/v2/servers | python -mjson.tool
}

function gsbucket {
	gsutil ls $GSUTIL_BUCKET/$1
}

# varnish
alias vl='varnishlog -m rxURL:/rss/blog -c'
function vpurge {
    curl -s -v -o /dev/null -X $VARNISH_VERB https://$VARNISH_USER:$VARNISH_PASS@$VSCO_PROD$1 2>&1 >/dev/null | grep HTTP
}
function vpurges {
    curl -s -v -o /dev/null -X $VARNISH_VERB https://$VARNISH_USER:$VARNISH_PASS@$VSCO_STAGING$1 2>&1 >/dev/null | grep HTTP
}
function vpurged {
    curl -s -v -o /dev/null -X $VARNISH_VERB https://$VARNISH_USER:$VARNISH_PASS@$VSCO_DEV$1 2>&1 >/dev/null | grep HTTP
}

# Java
export CLASSPATH=~/bin:$CLASSPATH

# OpsCode / Chef
export OPSCODE_USER=zo

# some default locations
export NGINX_HOME=/usr/local/Cellar/nginx/current
export APACHE_HOME=/usr/local/apache2
export NPM_HOME=/usr/local/share/npm/
export ANDROID_HOME=~/adt-bundle-mac/sdk
export HEROKU_HOME=/usr/local/heroku
export NPM_RELATIVE="./node_modules/.bin"
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export GSUTIL_HOME=~/bin/gsutil

# Python
export PYTHONPATH=~/
source $(brew --prefix autoenv)/activate.sh
alias e='source .env/bin/activate.sh'

# export PATH=$HOME/.rvm/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$PATH:$NPM_HOME/bin
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HEROKU_HOME/bin
export PATH=$PATH:$GSUTIL_HOME
export PATH=$PATH:.

export PATH=~/bin:$PATH
export PATH=$NPM_RELATIVE:$PATH

# LUNCHY
LUNCHY_DIR=$(dirname `gem which lunchy`)/../extras
  if [ -f $LUNCHY_DIR/lunchy-completion.bash ]; then
    . $LUNCHY_DIR/lunchy-completion.bash
fi

# RVM
# source ~/.rvm/scripts/rvm

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

export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUPSTREAM="auto"

. ~/.git-prompt.sh
. ~/.git-completion.sh
. ~/.colors_bash

export PS1='\[\e[0;92m\]\T\[\e[0m\] \[\e[0;92m\]`hostname`\[\e[0m\]\[\e[0;92m\]$(__git_ps1 " (%s)")\[\e[0m\] \[\e[0;32m\]\W > \[\e[0m\]'

# misc
alias curly='curl -w "@$HOME/.curl_format" -o /dev/null -s -v'
alias ip='curl -s http://ipecho.net/plain; echo'
alias loadspeed='phantomjs /Users/zo/performance/loadspeed.js'

# photo
alias ph='cd ~/Photos'
alias photo='ssh $PHOTO_USER@$PHOTO_HOST'
alias photo_mount='sshfs $PHOTO_USER@$PHOTO_HOST: $PHOTO_DIR_LOCAL_MOUNT'
alias photo_umount='umount $PHOTO_DIR_LOCAL_MOUNT'
alias photo_cpr='photo_umount; photo_mount; cp -R -v $PHOTO_DIR_LOCAL_MOUNT/* $PHOTO_DIR_REMOTE/.'

function jalbum_all {
	for d in `find . -type d | grep -v 'thumbs\|slides\|res\|jalbum\|\.$'`
	do
		(cd $d && jalbum)
	done
	photo_push
}

function jalbum_convert_all {
	for d in `find . -type d | grep -v 'thumbs\|slides\|res\|jalbum\|\.$'`
	do
		(cd $d && jalbum_convert)
	done
	photo_push
}

function jalbum_convert {
	photo_convert
	jalbum
}

function jalbum {
	tolower

	JALBUM_HOME=/Users/zo/Photos
	JALBUM_SETTINGS=$JALBUM_HOME/jalbum-settings.jap

	JALBUM_JAR="/Applications/jAlbum.app/Contents/Resources/Java/JAlbum.jar"
	JALBUM_SKIN=Turtle

	time java -Xmx1024M -jar $JALBUM_JAR -directory "`pwd`" -outputDirectory "`pwd`" -skin $JALBUM_SKIN -projectFile $JALBUM_SETTINGS -customImageOrdering
	rm humans.txt
}


function photo_convert {
	if [ ! -f meta.properties.original ]
	then
		dos2unix meta.properties
		dos2unix albumfiles.txt

		cp meta.properties meta.properties.original
		cp albumfiles.txt albumfiles.txt.original

		cp meta.properties comments.properties
		sed '/title=/d'    comments.properties > foo; mv foo comments.properties
		sed '/subtitle=/d' comments.properties > foo; mv foo comments.properties
		sed '/date=/d'     comments.properties > foo; mv foo comments.properties
		sed 's/=/.jpg=/'   comments.properties > foo; mv foo comments.properties
		sed '/^$/d'        comments.properties > foo; mv foo comments.properties
		sort comments.properties > foo; mv foo comments.properties

		grep 'title=\|date=\|description=\|ordering=' meta.properties > foo; mv foo meta.properties
		sed 's/subtitle=/description=/' meta.properties > foo; mv foo meta.properties

		if ! grep ordering meta.properties; then
			echo 'ordering=custom' >> meta.properties
		fi

		if ! grep folderimage albumfiles.txt; then
    		echo '-folderimage.jpg' >> albumfiles.txt
    		echo '-folderthumb.jpg' >> albumfiles.txt
		fi

		description=`grep description= meta.properties`
		date=`grep date meta.properties | cut -d= -f2`
		sed '/description=/d' meta.properties > foo; mv foo meta.properties
		echo "description=$description<br/>$date" >> meta.properties
	fi
}

function photo_ls {
	remote_dir="$PHOTO_REMOTE_BASE/$1"
	photo "ls -la $remote_dir"
}

function photo_push {
	local_dir=$1
	remote_dir=$2

  	if [ "$local_dir" = "" ]; then
    	local_dir="."
  	fi

  	if [ "$remote_dir" = "" ]; then
		dir=`pwd`
		# http://stackoverflow.com/questions/16623835/bash-remove-a-fixed-prefix-suffix-from-a-string
		remote_dir=${dir#$PHOTO_LOCAL_HOME/}
  	fi

	remote_path="$PHOTO_REMOTE_BASE/$remote_dir"
	echo "Syncing photos in $local_dir to $remote_path"

	echo "Creating remote directory"
	photo "cd $PHOTO_REMOTE_BASE; mkdir $remote_dir"
	echo "created."

	rsync -Prtv --progress $local_dir/* $PHOTO_USER@$PHOTO_HOST:$PHOTO_REMOTE_HOME/$remote_path/.
}

function photo_pull {
	remote_dir=$1
	local_dir=$2

	if [ "$local_dir" = "" ]; then
		local_dir="."
	fi

	remote_path="$PHOTO_REMOTE_BASE/$remote_dir"
	echo "Pulling photos from $remote_path to $local_dir"

	rsync -Prtv --progress $PHOTO_USER@$PHOTO_HOST:$PHOTO_REMOTE_HOME/$remote_path/* $local_dir/. 
}

function photo_pull_jacq {
	local_mount=$PHOTO_MOUNT_JACQ
	local_dir=$PHOTO_LOCAL_HOME/JacqsPhone
	mkdir $local_dir
	find "$local_mount" -name \*JPG -exec cp -pvn {} $local_dir/. \;
	find "$local_mount" -name \*MOV -exec cp -pvn {} $local_dir/. \;
}

function photo_pull_zo {
	local_mount=$PHOTO_MOUNT_ZO
	local_dir=$PHOTO_LOCAL_HOME/ZoPhone
	mkdir $local_dir
	find "$local_mount" -name \*JPG -exec cp -pvn {} $local_dir/. \;
	find "$local_mount" -name \*MOV -exec cp -pvn {} $local_dir/. \;
}


function photo_pull_samsung {
    local_dir=$PHOTO_LOCAL_HOME/SamsungCamera
	camera_dir=/sdcard/DCIM/Camera/
	cd $local_dir
	adb pull $camera_dir
}

function photo_clear_samsung {
	camera_dir=/sdcard/DCIM/Camera
	echo "`adb shell \"ls -la $camera_dir\" | wc -l` files on Camera: $camera_dir"
	echo "Clearing"
	adb shell "rm $camera_dir/*"
	adb shell "ls -la $camera_dir"
	echo "Cleared $camera_dir"
}

function tolower {
	time for f in `find . -type f -maxdepth 1`; do echo "lowercasing $f"; mv "$f" "`echo $f | tr "[:upper:]" "[:lower:]"`"; done
}


function b64 {
	echo
	echo "$1" | base64 -D
	echo 
}

function pz {
  ps -aef | grep -i $1 | grep -v grep
}

function geo {
    curl -s http://freegeoip.net/json/$1 | python -mjson.tool 
}

function wildcard_csr {
	domain=$1
	openssl req -nodes -newkey rsa:2048 -nodes -keyout $domain.key -out $domain.csr -subj "/C=US/ST=Pennsylvania/L=Philadelphia/O=Phillies/CN=*.$domain"
}

function timestamp {
    date +"%s"
}

function timestamp-diff {
    cur=`timestamp`
    expr $cur - $1
}

function sshquiet {
    if [ "$#" == "0" ]; then
		echo
		echo "Sorry. I need a string to remove from ~/.ssh/known_hosts"
		echo
	else
		echo "Removing $1"
		grep -v $1 ~/.ssh/known_hosts > /tmp/hosts.tmp && mv /tmp/hosts.tmp ~/.ssh/known_hosts
	fi
}

function title {
  echo -e "\033];$1\007" 
  echo "Title set to $1"
}

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

  # deploy xrays
  echo 
  echo "DEPLOYING XRAYS to $env"
  echo
  cd $SRC_HOME/xrays
  git checkout master
  git pull
  cap fu force=$name

  # deploy camstore
  echo 
  echo "DEPLOYING CAMSTORE to $env"
  echo
  cd $SRC_HOME/camstore
  git checkout master
  git pull
  tag=`git tag | grep prod- | sort -n | tail -1`
  cap fu $env=$name from_tag="$tag"
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
  [[ $name = "staging"* ]] && env="staging"

  echo
  echo "RUNNING CHEF"
  echo

  # FIRST, COPY THE ID_RSA to ~/vsco/.ssh/id_rsa on the box
  echo 
  echo "UPLOADING SSH KEY"
  echo
  cd $SRC_HOME/vsco
  cas upload_ssh $env=$name

  # first, stop chef
  # cap chef_stop prod=all
  cap chef_stop  $env=$name

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





function rs-create-old {
  if [ "$1" = "" ]; then
	echo
    echo " Rackspace Pricing: http://www.rackspace.com/cloud/servers/pricing"
	echo
    echo " > knife rackspace flavor list"
    echo "              ID   Name                 VCPUs  RAM    Disk      Cost"
    echo "              2    512MB Standard       1      512    20GB      \$16"
    echo "              3    1GB Standard         1      1GB    40GB      \$44"
    echo "              4    2GB Standard         2      2GB    80GB      \$88   <- app/cam prod"
    echo "              5    4GB Standard         2      4GB    160GB     \$175"
    echo "              6    8GB Standard         4      8GB    320GB     \$350  <- giga lb"
    echo "              7    15GB Standard        6      15GB   620GB     \$657  <- tera lb"
    echo "              8    30GB Standard        8      30GB   1200GB    \$876  <- peta lb"
    echo " performance1-1    1 GB Performance     1      1GB    20GB      \$29"
    echo " performance1-2    2 GB Performance     2      2GB    40/20GB   \$58   <- app/cam prod NEW"
    echo " performance1-4    4 GB Performance     4      4GB    40/40GB   \$117"
    echo " performance1-8    8 GB Performance     8      8GB    40/80GB   \$234"
    echo " performance2-15   15 GB Performance    4      15GB   40/150GB  \$496"
    echo " performance2-30   30 GB Performance    8      30GB   40/300GB  \$993  <- peta lb NEW"
    echo " performance2-60   60 GB Performance    16     61GB   40/600GB  \$1986 <- exa lb"
    echo " performance2-90   90 GB Performance    24     92GB   40/900GB  \$2978"
    echo " performance2-120  120 GB Performance   32     122GB  40/1200GB \$3971"
    echo
    echo " rs-create <env> <name> <run_list> <flavor> <image> <location>"
    echo
    echo "       <env>      "
    echo "       <name>     "
    echo "       <run_list> (needs single quotes)"
    echo "       <flavor>   defaults to \"2\" (512MB small)"
    echo "       <image>    defaults to \"Ubuntu 12.10\". Use prod-app, prod-resizer, prod-store, or dev-app"
    echo "       <location> defaults to \"dfw\" (\"ord\" is a valid alternative)"
	echo

    echo "Ex: rs-create dev app99 'role[app-all]' dev-app"
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

  # knife rackspace image list --rackspace-version v2
  if [ "$5" = "" ]; then
    # image="8a3a9f96-b997-46fd-b7a8-a9e740796ffd" 
    image="b3ed73ef-b922-4b61-bb4d-472bb52e6326"
  elif [ "$5" = "ubuntu" ]; then
    image="b3ed73ef-b922-4b61-bb4d-472bb52e6326"
  elif [ "$5" = "prod-app" ]; then
    image="9d17ce76-dce8-488e-8811-0620d495349a"
  elif [ "$5" = "prod-resizer" ]; then
    image="f1262e39-9d0c-4d45-b17c-23438b6506ff"
  elif [ "$5" = "prod-store" ]; then
    image="be5a693d-890f-4255-9954-9a1a9a84bfdd"
  elif [ "$5" = "dev-blank-app" ]; then
	image="96f429fe-c4d3-494a-b225-97f57363ab32"
  elif [ "$5" = "dev-blank-cam" ]; then
	image="fc177284-d31f-4674-a579-e497b14b50d8"
  else
    image="b3ed73ef-b922-4b61-bb4d-472bb52e6326"
  fi


  if [ "$6" = "" ]; then
    location="dfw"
  else
    location=$6
  fi

  # endpoint="https://$location.servers.api.rackspacecloud.com/v2"
  fullname=$env-$name
  echo "Creating $fullname with a run_list of $run_list, flavor $flavor, image $image, in $location"
  # json='{ "attributes": { "env": "dev", "run_list": [ "role[standalone]" ] } }'

  c
  bootstrap="vsco-ubuntu"
  time knife rackspace server create -d $bootstrap --image $image --flavor $flavor --server-name $fullname --node-name $fullname --run-list $run_list --environment $env --rackspace-region $location

  # or-create $fullname
}



function rs-create {
  	if [ "$1" = "" ]; then
    	echo
    	echo " Rackspace Pricing: http://www.rackspace.com/cloud/servers/pricing"
    	echo
    	echo " > knife rackspace flavor list"
    	echo "              ID   Name                 VCPUs  RAM    Disk      Cost"
    	echo "              2    512MB Standard       1      512    20GB      \$16"
    	echo "              3    1GB Standard         1      1GB    40GB      \$44"
    	echo "              4    2GB Standard         2      2GB    80GB      \$88   <- app/cam prod"
    	echo "              5    4GB Standard         2      4GB    160GB     \$175"
    	echo "              6    8GB Standard         4      8GB    320GB     \$350  <- giga lb"
    	echo "              7    15GB Standard        6      15GB   620GB     \$657  <- tera lb"
    	echo "              8    30GB Standard        8      30GB   1200GB    \$876  <- peta lb"
    	echo " performance1-1    1 GB Performance     1      1GB    20GB      \$29"
    	echo " performance1-2    2 GB Performance     2      2GB    40/20GB   \$58   <- app/cam prod NEW"
    	echo " performance1-4    4 GB Performance     4      4GB    40/40GB   \$117"
    	echo " performance1-8    8 GB Performance     8      8GB    40/80GB   \$234"
    	echo " performance2-15   15 GB Performance    4      15GB   40/150GB  \$496"
    	echo " performance2-30   30 GB Performance    8      30GB   40/300GB  \$993  <- peta lb NEW"
    	echo " performance2-60   60 GB Performance    16     61GB   40/600GB  \$1986 <- exa lb"
    	echo " performance2-90   90 GB Performance    24     92GB   40/900GB  \$2978"
    	echo " performance2-120  120 GB Performance   32     122GB  40/1200GB \$3971"
    	echo
    	echo " rs-create <env> <name> <run_list> <location> <flavor> <image>"
    	echo
    	echo "       <env>      "
    	echo "       <name>     "
    	echo "       <run_list> (needs single quotes)"
    	echo "       <location> defaults to \"dfw\" (\"hkg\" is a valid alternative)"
    	echo "       <flavor>   defaults to \"2\" (512MB small)"
    	echo "       <image>    defaults to \"Ubuntu 12.10\""
    	echo
	
    	echo "Ex: rs-create green app99 'role[app-all]' hkg performance1-2"
    	echo
    	return
  	fi

  	env=$1
  	name=$2
  	run_list="'$3'"

  	if [ "$4" = "" ]; then
    	rs_location=$RS_DEFAULT_LOCATION
  	else
    	rs_location=$4
  	fi

  	if [ "$5" = "" ]; then
    	rs_flavor="performance1-1"
  	else
    	rs_flavor=$5
  	fi
		
	rs-default-image $rs_location

  	fullname=$env-$rs_location-$name
  	if [ "$rs_location" = "dfw" ]; then
  		fullname=$env-$name
	fi
  	echo "Creating $fullname with a run_list of $run_list, flavor $rs_flavor, image $rs_image, in $rs_location"

	# Authorize ourselves
	rs-auth

	# Create the server
	rs_response=`curl -s https://$rs_location.servers.api.rackspacecloud.com/v2/$RS_ACCOUNT/servers \
		-X POST \
		-H "Content-Type: application/json" \
		-H "X-Auth-Token: $RS_TOKEN" \
		-H "X-Auth-Project-Id: vsco" \
		-d"{
            \"server\" : {
                    \"name\" : \"$fullname\",
                    \"imageRef\" : \"$rs_image\",
                    \"flavorRef\" : \"$rs_flavor\",
                    \"metadata\" : {
                        \"My Server Name\" : \"$fullname\"
                    }
                }
            }" `

	# parse the server_id and pw out of the response
	echo $rs_response | js
	rs_server_id=`echo $rs_response | underscore extract "server.id" --outfmt text`
	rs_pw=`echo $rs_response | underscore extract "server.adminPass" --outfmt text`

	# wait for the server to get created
	rs-wait $rs_location $rs_server_id

	# get the IP address
	ip=`rs-ip $rs_location $rs_server_id`
	
	# Chef Bootstrap
	echo "Bootstrapping $ip with $rs_pw"
	a=`timestamp`
	c
	knife bootstrap $ip -E $env -d vsco-ubuntu -r $run_list -N $fullname -x root -P $rs_pw -V
	cd -
	echo "Bootstrapping Server $fullname took `timestamp-diff $a `seconds"
}

function rs-wait {
	rs_location=$1
	rs_id=$2

	a=`timestamp`
	while true
	do 
		sleep 1
		echo -n "."
		status=`rs-status $rs_location $rs_id`
		if [ $status == "ACTIVE" ]
		then 
			echo ""
			echo "Creating Server took `timestamp-diff $a `seconds"
			break
		fi
	done
}

function rs-default-image {
	rs-args-one $*
	case "$rs_location" in
		dfw)
 	    	rs_image="b3ed73ef-b922-4b61-bb4d-472bb52e6326"
			;;
		hkg)
			rs_image="d45ed9c5-d6fc-4c9d-89ea-1b3ae1c83999"
			;;
	esac
	# echo "IMAGE for $rs_location is $rs_image"
}

function rs-auth {
    export RS_TOKEN=`curl -s -H "Content-Type: application/json" https://auth.api.rackspacecloud.com/v2.0/tokens  -XPOST -d"{ \"auth\": { \"RAX-KSKEY:apiKeyCredentials\": { \"username\": \"$RS_USERNAME\", \"apiKey\": \"$RS_APIKEY\" } } }" | underscore extract 'access.token.id' --outfmt text`

	if [ -z "$RS_TOKEN" ]; then
		echo
    	echo "Unable to get RS_TOKEN!"
		echo "RS_USERNAME: $RS_USERNAME"
		echo "RS_APIKEY:   $RS_APIKEY"
		echo
	fi 
}

function rs-args-two {
    if [ "$#" == "1" ]; then
        rs_location=$RS_DEFAULT_LOCATION
        rs_server=$1
    else
        rs_location=$1
        rs_server=$2
    fi
}

function rs-args-one {
    if [ "$#" == "0" ]; then
        rs_location=$RS_DEFAULT_LOCATION
    else
        rs_location=$1
    fi
}


function rs-getid {
	rs-serverinfo $* | underscore pluck 'id' --outfmt text
}

function rs-parsename {
	IFS=- read env rs_location name <<< "$1"

    # if its in the "old" naming format, default the location
    if [ "$name" = "" ]; then
		name=$rs_location
		rs_location="dfw"
	fi
}

function rs-serverinfo {
	fullname=$1
	rs-parsename	$fullname
	rs-list $rs_location | underscore select ":has(:root > .name:val(\"$fullname\"))" | js
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

	fullname=$1
	rs-parsename	$fullname

	echo -n "Authorizing ..."
	rs-auth

	rs_server=`rs-getid $fullname`

	echo "Deleting Server $rs_server ..."
	output=`curl -s -v https://$rs_location.servers.api.rackspacecloud.com/v2/$RS_ACCOUNT/servers/$rs_server -X DELETE -H "X-Auth-Token: $RS_TOKEN"`
	if echo $output | grep " 204 No Content"
	then
		echo "Deleted"
	else
		echo "Server NOT Deleted:"
		echo $output
	fi

	echo
	echo "Deleting DNS entries"
    dns-delete $fullname           vsco.co
    dns-delete $fullname-private   vsco.co

	echo
	echo "Deleting Opscode entries"
    knife client delete -y $fullname
    knife node   delete -y $fullname

	echo
	echo "Deleting ObjectRocket entries"
    or-delete $fullname
	echo "done"

	echo
	echo "Deleting SSH cache"
	sshquiet $fullname
	echo "done"
}

function rs-list {
	rs-args-one $*
	rs-auth
	curl -s https://$rs_location.servers.api.rackspacecloud.com/v2/$RS_ACCOUNT/servers/detail -H "X-Auth-Token: $RS_TOKEN" | js
}

function rs-info {
	rs-args-two $*
	rs-auth
	curl -s https://$rs_location.servers.api.rackspacecloud.com/v2/$RS_ACCOUNT/servers/$rs_server -H "X-Auth-Token: $RS_TOKEN" | js
}

function rs-ip {
	rs-args-two $*
	rs-auth
	curl -s https://$rs_location.servers.api.rackspacecloud.com/v2/$RS_ACCOUNT/servers/$rs_server -H "X-Auth-Token: $RS_TOKEN" | underscore extract 'server.accessIPv4' --outfmt text
}

function rs-status {
	rs-args-two $*
	rs-auth
	curl -s https://$rs_location.servers.api.rackspacecloud.com/v2/$RS_ACCOUNT/servers/$rs_server -H "X-Auth-Token: $RS_TOKEN" | underscore extract 'server.status' --outfmt text
}

function rs-images {
	rs-args-one $*
	rs-auth
	curl -s https://$rs_location.servers.api.rackspacecloud.com/v2/$RS_ACCOUNT/images/detail -H "X-Auth-Token: $RS_TOKEN" | js
}

function rs-flavors {
	rs-args-one $*
	rs-auth
	curl -s https://$rs_location.servers.api.rackspacecloud.com/v2/$RS_ACCOUNT/flavors -H "X-Auth-Token: $RS_TOKEN" | js
}


function do-list() {
    curl -s "https://api.digitalocean.com/droplets/?client_id=$DO_CLIENT_ID&api_key=$DO_API_KEY" | python -mjson.tool
}

function do-keys() {
    curl -s "https://api.digitalocean.com/ssh_keys/?client_id=$DO_CLIENT_ID&api_key=$DO_API_KEY" | python -mjson.tool
}

function do-create {
  if [ "$1" = "" ]; then
    echo
    echo " DigitalOcean Pricing: https://www.digitalocean.com/pricing"
    echo
    echo "   ID   Mem    VCPUs  Net    Disk  Cost"
    echo "   66   512MB  1      1TB    20GB  \$5/mo"
    echo "   63   1GB    1      2TB    30GB  \$10/mo"
    echo "   62   2GB    2      3TB    40GB  \$20/mo  <- app/cam prod"
    echo "   64   4GB    2      4TB    60GB  \$40/mo"
    echo "   65   8GB    4      5TB    80GB  \$80/mo  <- giga lb"
    echo "   61   16GB   8      6TB    160GB \$160/mo <- tera lb"
    echo "   60   32GB   12     7TB    320GB \$320/mo <- peta lb"
    echo "   70   48GB   16     8TB    480GB \$480/mo"
    echo "   69   64GB   20     9TB    640GB \$640/mo"
    echo "   68   96GB   24     10TB   960GB \$960/mo"
    echo
    echo " do-create <env> <name> <run_list> <id> <image> <location>"
    echo
    echo "       <env>      "
    echo "       <name>     "
    echo "       <run_list> (needs single quotes)"
    echo "       <flavor>   defaults to \"2\" (512MB small)"
    echo "       <image>    defaults to \"3101891\""
    echo "       <location> defaults to \"4\" (google nyc)"
    echo

    echo "Ex: do-create green app99 'role[app-all]' 62"
    echo
    echo "To see list of available images:"
    echo 'curl "https://api.digitalocean.com/images/?client_id=$DO_CLIENT_ID&api_key=$DO_API_KEY"  | js'
    echo
    return
  fi


  env=$1
  name=$2
  run_list="'$3'"

  if [ "$4" = "" ]; then
    flavor="66"
  else
    flavor=$4
  fi

  # knife rackspace image list --rackspace-version v2
  if [ "$5" = "" ]; then
    image="3447912"
  elif [ "$5" = "ubuntu.12.10" ]; then
    image="3447912"
  elif [ "$5" = "ubuntu.14.04" ]; then
    image="3240036"

  # PRIVATE IMAGES
  elif [ "$5" = "prod-app" ]; then
    image="9d17ce76-dce8-488e-8811-0620d495349a"
  elif [ "$5" = "prod-resizer" ]; then
    image="f1262e39-9d0c-4d45-b17c-23438b6506ff"
  elif [ "$5" = "prod-store" ]; then
    image="be5a693d-890f-4255-9954-9a1a9a84bfdd"
  elif [ "$5" = "dev-app" ]; then
    image="1dc261fa-a5b7-4321-b48e-7f1441c88cbe"
  else
    image="3447912"
  fi


  if [ "$6" = "" ]; then
    location="4"
  else
    location=$5
  fi

  bootstrap="vsco-ubuntu"
  ssh_key_id=54102
  fullname=$env-$name
  echo "Creating $fullname with a run_list of $run_list, flavor $flavor, image $image, in $location"


  curl "https://api.digitalocean.com/droplets/new?client_id=$DO_CLIENT_ID&api_key=$DO_API_KEY&name=$fullname&size_id=$flavor&image_id=$image&region_id=$location&ssh_key_ids=$ssh_key_id&private_networking=true"
  cd ~/tugboat
  # tugboat create $fullname -s $flavor -i $image -r $location -k $ssh_key_id -p
  tugboat wait $fullname

  c
  ip=`tb info $fullname | grep IP | tr -s ' ' | cut -d ' ' -f 2`
  knife bootstrap $ip -E $env -d $bootstrap -r $run_list -N $fullname -i ~/.ssh/do_rsa -x root -V

  # knife bootstrap 162.243.101.134 -E 'green' -d vsco-ubuntu -r 'role[lb]' -N green-fu -V -x root -i ~/.ssh/do_rsa
  # or-create $fullname
}

function do-delete {
    if [ "$1" = "" ]; then
        echo
        echo " do-delete <name>"
        echo
        echo "Ex: do-delete dev-xray9"
        echo
        return
    fi

    tb destroy $1 

    or-delete $1
    dns-delete $1           vsco.co
    dns-delete $1-private   vsco.co

    cd -
}


function or {
    mongo -u $OR_USER -p $OR_PASS $OR_HOST/$1 $2 $3 $4
}

function or-create {
  name=$1
  ip=`knife status | grep $name | cut -f 4 -d ',' | tr -d ' '` 
  echo "OR Creating ACL $name $ip"
  curl --data "api_key=$OR_KEY&doc={\"cidr_mask\": \"$ip/32\", \"description\": \"$name\"}" $OR_API_HOST/acl/add
}


function or-permit {
  name=`whoami`-dev
  ip=`curl -s http://ipecho.net/plain`
  echo "OR Creating ACL $name $ip"
  curl --data "api_key=$OR_KEY&doc={\"cidr_mask\": \"$ip/32\", \"description\": \"$name\"}" $OR_API_HOST/acl/add
}

function or-delete {
  name=$1
  echo "OR Deleting Name $name..."
  ip=`knife status | grep $name | cut -f 4 -d ',' | tr -d ' '` 
  echo "OR Deleting ACL $ip..."
  or-delete-ip $ip
}

function or-delete-ip {
  curl -s --data "api_key=$OR_KEY&doc={\"cidr_mask\": \"$1/32\"}" $OR_API_HOST/acl/delete
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

function rs-delete-old {
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

	or-delete $1

  	cd -
}

function aws-bootstrap {
	env="blue"
	knife bootstrap $1 -N $env-$2 -r 'role[redis]' -E $env -d vsco-amazon -V -x ubuntu -i ~/.ssh/$AWS_KEY_NAME.pem --hint '{"ec2":true}' --bootstrap-version="11.12.4"
}

# EOL conversions
function dos2unix {
	cat $1 | tr -d '\r' > foo.tmp
	mv foo.tmp $1
}

function unix2mac {
	cat $1 | tr '\n' '\r' > foo.tmp
	mv foo.tmp $1
}

function mac2unix {
	cat $1 | tr '\r' '\n' > foo.tmp
	mv foo.tmp $1
}


# The next line updates PATH for the Google Cloud SDK.
if [ -f /Users/zo/Downloads/google-cloud-sdk/path.bash.inc ]; then
  source '/Users/zo/Downloads/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Users/zo/Downloads/google-cloud-sdk/completion.bash.inc ]; then
  source '/Users/zo/Downloads/google-cloud-sdk/completion.bash.inc'
fi


. ~/.z.sh
. ~/.bashrc_private

# added by travis gem
[ -f /Users/zo/.travis/travis.sh ] && source /Users/zo/.travis/travis.sh
