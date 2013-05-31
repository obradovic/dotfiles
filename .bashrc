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
# export OPENSSL_HOME=/usr/local/ssl/
export NPM_RELATIVE="./node_modules/.bin"
export PHP_HOME=$(brew --prefix josegonzalez/php/php54)
export GROOVY_HOME=/usr/local/opt/groovy/libexec

# Python
export PYTHONPATH=~/




function rs-create {
  if [ "$1" = "" ]; then
	echo
    echo " Rackspace Pricing: http://www.rackspace.com/cloud/servers/pricing"
	echo
    echo " > knife rackspace flavor list"
    echo "       ID  Name                     VCPUs  RAM    Disk"
    echo "       2   512MB Standard Instance  1      512    20 GB"
    echo "       3   1GB Standard Instance    1      1024   40 GB"
    echo "       4   2GB Standard Instance    2      2048   80 GB    <- prod app default"
    echo "       5   4GB Standard Instance    2      4096   160 GB"
    echo "       6   8GB Standard Instance    4      8192   320 GB   <- prod lb giga"
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
    # knife client delete $1

  	cd -
}

