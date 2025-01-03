#
# GENERIC BASH OPTIONS
#
set -o vi
shopt -s extglob
shopt -s histappend
umask 0022

# GENERIC BASH
export EDITOR=vi
export BASH_SILENCE_DEPRECATION_WARNING=1  # https://www.addictivetips.com/mac-os/hide-default-interactive-shell-is-now-zsh-in-terminal-on-macos/
export CLICOLOR=1
export DYLD_LIBRARY_PATH=/usr/local/opt/mysql-client/lib/
export LESS="-XFR"
export SRC_HOME="$HOME/phillies"
export PIE=$SRC_HOME/pie
# export TERM=xterm
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# HISTORY
export HISTFILE=~/.history_bash
export HISTFILESIZE=100000
export HISTIGNORE="&:ls:[bf]g:exit:[ \t]*"
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

#
# GENERIC BASH ALIASES AND FUNCTIONS
#
alias ,='. ~/.bashrc'
alias m='make'
alias t='TIMEFORMAT="That took %1R seconds" && time'
alias curly='curl -w "@$HOME/.curl_format" -o /dev/null -s -v'
alias ip='curl -s http://ipecho.net/plain; echo'
alias loadspeed='phantomjs $HOME/.loadspeed.js'
alias la='ls -la'
alias dir='la'
alias dor='la'
alias dri='la'
alias dur='la'
alias dirw='la | grep drw'
alias j='jobs'
alias 1='fg %1'
alias 2='fg %2'
alias 3='fg %3'
alias 4='fg %4'
alias bi='vi'
alias del='rm'
alias vig='mvim'
alias vo='vi'
alias vu='vi'
alias mroe='more'
alias copy='cp'
alias move='mv'
alias bas='vi ~/.bashrc; sleep 0.1; . ~/.bashrc'
alias bass='vi ~/.bashrc_private; sleep 0.1; . ~/.bashrc'
alias basss='vi ~/.bashrc_phillies; sleep 0.1; . ~/.bashrc_phillies'
alias please='sudo'
alias sudo='sudo '  # from http://www.shellperson.net/using-sudo-with-an-alias/
alias yolo="sudo $(history | tail -2 | head -1 | tr -s ' ' | cut -d' ' -f2-)"
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
alias du1='du -h -d 1 | sort -h'
alias du2='du -h -d 2 | sort -h'
alias dfk='df -h -k'
alias tl='tail -f'
alias beep='for i in {1..3} ; do tput bel; sleep 0.5; done'
alias js='python3 -m json.tool'
alias less='less -X -F'
alias grepl='grep --line-buffered'
alias noempty='egrep --line-buffered -v "^[[:space:]]*$"'
alias nojello='grep --line-buffered -v jello'
alias ports='netstat -tulan'
alias .ale='make'
# alias make=gmake
alias utc='date -u'
alias ut='utc'
alias today='note today'
alias x=exit
alias mini='ssh 192.168.1.42'
alias hosts='sudo vi /etc/hosts'
alias teep='pmset sleepnow'

function mcd {
    mkdir "$1"
    cd "$1"
}
function fin {
    find . -name \*$1\* ${@:2}
}
function pz {
  ps -aef | grep -i $1 | grep -v grep
}
function geo {
    ip="$1"
    if [ -z "$ip" ]; then
        ip=check
    fi
    local info=`curl -s "http://api.ipstack.com/$ip?access_key=$IPSTACK_TOKEN"`
    echo $info | jq -r '. | "\(.city) \(.region_name) \(.country_code)"'
    # echo $info
    # curl -s "http://api.ipstack.com/$ip?access_key=$IPSTACK_TOKEN" | jq -r '. | "\(.city) \(.region_name) \(.country_code)"'
}
function who {
    ip="$1"
    if [ -z "$ip" ]; then
        ip=`ip`
    fi
    whois $ip | grep OrgName | tr -s ' ' | cut -d' ' -f2-
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
function nohuptime {
    nohup bash -c 'time $* > nohup.out 2>&1'
}
function title {
  echo -e "\033];$1\007"
  echo "Title set to $1"
}


#
# PHILS
#
alias python-prod='ENV=prod $PIE/.env.Darwin/bin/python'
alias medicalbot='python-prod $PIE/uploader/draft_prospect_link/medicalbot.py'
alias allowlist='python-prod $PIE/bin/allowlist.py'
alias adrian-db='t python3 $PIE/biomech/adrian_db.py'
alias adrian-db-write='t python3 $PIE/biomech/adrian_db.py --write-db --adrian-filename'
alias adrian-process='t python3 $PIE/biomech/adrian_process.py --hawkeye-filename'
alias adrian='t python3 $PIE/biomech/adrian.py --hawkeye-filename'
function biohealth {
    DIR=biomech make health
    # (pie && DIR=biomech make health)
}

export APP=db


#
# GITHUB
#
function pr {
    title="$1"
    # if [ -z "$title" ]; then
        # echo
        # echo "    Please set the title of the PR"
        # echo
        # return
    # fi
    output=`gh pr create --base main --fill 2>&1`
    if [ $? -ne 0 ]; then
        echo
        echo "ERROR"
        echo "ERROR"
        echo
        echo "$output"
        echo
        echo "ERROR"
        echo "ERROR"
        echo
        return
    fi
    echo $output
    url=`echo $output | grep https`
    echo "$url is our URL"
    open "$url"
}

function beeper {
    runs=`gh run list --limit 30 --repo PhilliesAnalytics/pie`
    in_progress_ids=`echo "$runs" | grep in_progress | tr -d ' ' | cut -d$'\t' -f7`
}



#
# GITHUB ACTIONS
#
alias g='cd $PIE/../.github'
alias w='g && cd workflows'
alias sc='g && cd scripts'


#
# DOCKER
#
alias d='docker'
alias dc='d container'
alias di='d image'
alias dps='d ps -a'
alias doc='cd $PIE/etc/docker/pie'
alias ama='cd $PIE/dash/ama'
alias amad='cd $PIE/etc/docker/dash'
alias drun='docker container run'
# alias pc-up="(pie && make pc-up)"
# alias pc-down="(pie && make pc-down)"
alias enter="(pie && make enter)"

function ubuntu-R {
    run-in-container flex "/usr/bin/R --no-save -q"
}
alias dr=ubuntu-R

function dbash {
    # run-in-container $1 /bin/bash
    local image="$1"
    # local image_full="gcr.io/phil-new/$image"
    if [[ "$image" == *"/"* ]]; then
        local image_full="$image"
    else
        local image_full="gcr.io/phil-new/$image"
    fi

    echo
    echo "  Entering $image_full"
    echo
    docker run -it --entrypoint /bin/bash "$image_full"
}
alias dbash-flex='dbash flex'
alias dbash-composer='dbash composer'
alias dbash-composer-r='dbash composer-r'
alias dbash-r='dbash rocker/tidyverse:4.0.4'


function run-in-container {
    local image="$1"
    local cmd="$2"
    local image_full="gcr.io/phil-new/$image"

    if [[ "$image" == *"/"* ]]; then
        image_full="$image"
    fi
    echo "image: $image_full"

    # start it, if its not running
    local container_id=`docker ps | grep $image_full | cut -d' ' -f1`
    if [ -z "$container_id" ]; then
        # echo "Starting container $image_full"
        started_id=`docker container run -p 8000:80 -d --hostname $image --detach $image_full`
        container_id=$started_id
    fi
    container_id=`echo $container_id | cut -c-12`   # make it a short id

    echo
    echo "  Entering $image_full container $container_id"
    echo
    docker container exec -it $container_id $cmd

    # stop it, if it wasnt running
    if [ -n "$started_id" ]; then
        docker container stop -t 0 $started_id > /dev/null
    fi
}
# etc=/Applications/Docker.app/Contents/Resources/etc
# ln -s $etc/docker.bash-completion $(brew --prefix)/etc/bash_completion.d/docker
# ln -s $etc/docker-compose.bash-completion $(brew --prefix)/etc/bash_completion.d/docker-compose


#
# AWAIR
#
alias aw='awair --mac 70:88:6b:14:10:a1'


#
# KUBE
#
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
alias k=kubectl
alias desc='k describe'
alias kns=kubens
alias kaf='k apply -f'
alias kcf='k create --save-config -f'
alias kall='k get all -A --show-labels'
alias ke='k exec'
alias kc='k config'
alias kl='k logs --timestamps --prefix -f'
function kcs {
    local substring="$1"

    if [ -z "$substring" ]; then
        echo
        echo "Please enter a partial context name:"
        echo
        kubectl config get-contexts | tr -s " " | sed -e "s/ /,/g" | cut -d',' -f1-2 | tr -s "," "\t" | grep -v CURRENT
        echo
        return
    fi

    local new_context=`kc get-contexts -o name | grep "$substring" | head -1`
    # echo "Setting context to: $new_context"
    echo
    kc use-context $new_context
    echo
    kc get-contexts | tr -s " " | sed -e "s/ /,/g" | cut -d',' -f1-2 | tr -s "," "\t" | grep -v CURRENT
    echo
}

function kg {
    kubectl get $*
}
function kj {
    kg $* -o json | jq .
}
function ky {
    kg $* -o yaml | yq .
}

function bp {
    cd $PIE
    make bash-pod POD=$1
    cd -
}

function pod-bash {
    local pod_pattern="$1"
    local pods=`podsa | grep "$pod_pattern" | tr -s ' '`
    local namespace=`echo $pods | cut -d' ' -f1`
    local pod_name=`echo $pods | cut -d' ' -f2`
    echo "Bashing into: $pod_name"

    local shell=/bin/bash
    if [ "$namespace" != "default" ]; then
        echo "Using /bin/sh instead..."
        shell=/bin/sh
    fi
    if [[ "$pod_name" == *"rocky"* ]]; then
        echo "Using /bin/sh instead..."
        shell=/bin/sh
    fi
    if [[ "$pod_name" == *"haproxy"* ]]; then
        echo "Using /bin/sh instead..."
        shell=/bin/sh
    fi

    kubectl exec --namespace "$namespace" -it "$pod_name" -- "$shell"
    # bp "$pod"
}

function pod-log {
    local pod_pattern="$1"
    local logfile="$2"
    local pod=`podsa | grep -v NAME | sort | grep "$pod_pattern" | grep Running | head -1 | tr -s ' ' | cut -d' ' -f2`

    # echo "pod is $pod"
    # echo "logfile is $logfile"

    if [ -n "$logfile" ]; then
        echo "Tailing pod: $pod logfile: "$logfile""
        filename="/var/log/uwsgi-$logfile.log"
        k exec "$pod" -- ls -al "$filename"
        echo
        sleep 1
        k exec "$pod" -- tail -f "$filename"
    else
        echo "Tailing pod: $pod"
        kl "$pod"
    fi
}

function pod-log-api-http {
    pod-log api api-http
}
function pod-log-api-http-clean {
    pod-log api api-http | grep -v "jello\|reset\|Permission\|Token\ user\|schedule\/near\/143"
}
function pod-log-api-ws {
    pod-log api api-ws
}
function pod-log-api-ws-clean {
    pod-log api api-ws | grep -v "jello\|reset\|\- \-\ 0\ "
}
function pod-log-api-ws {
    pod-log api api-ws
}
function pod-log-hap {
    pod-log hap
}
function pod-log-hap-clean {
    pod-log hap | grep -v "STATS\|GET / \|NOSRV\|SSL handshake failure"
}
function pod-log-rocky {
    pod-log rocky
}

function pod-log-all {
    kl -l org=phillies
}

function clients {
    curl -s https://ws.phils.io/clients | jq .
}
function clients-local {
    curl -s http://localhost:81/clients | jq .
}

function node-pods {
    local node="$1"
    if [ -z "$node" ]; then
        echo
        echo "  I need a node name. Here are our nodes:"
        echo
        kg nodes
        echo
        return
    fi
    kg node "$node"  -o json | jq .status.images[].names | grep -v "gcr.io\|\]\|\[" | sort
}

function ingress-annotations {
    local ingress_name=$1
    if [ -z $ingress_name ]; then
        ingress_name=ingress-phillies
    fi

    # echo "Ingress: $ingress_name"
    # ret=`kubectl get ingress $ingress_name -o json`
    ret=`kubectl get ingress $ingress_name -o json | jq .metadata.annotations`
    echo "$ret" | jq -s .
}
function forwarding-rules {
    annotations=`ingress-annotations | grep forwarding-rule`
    echo "$annotations" | tr -s ' ' | cut -d' ' -f3 | tr -d '"' | tr -d ','
}

alias configmaps='kg configmaps -A'
alias daemonsets='kg daemonsets -A -o wide'
alias dms=daemonsets
alias deps='kg deployments'
alias depsa='deps -A'
alias events='kg events -w --sort-by=.metadata.creationTimestamp'
alias eventsa='events -A'
alias nodes='kg nodes -o wide'
alias nodesa='nodes -A'
alias pods='kg pods -o wide | grep -v Evicted'
alias podsa='kg pods -o wide -A | grep -v Evicted'
alias podsc='pods | grep "Running\|Creat" | grep -v "^airflow\|composer-fluentd" | grep -v Error'
alias pod-nodes=node-pods
alias ingress='kg ingress -A'
alias ingresses=ingress
alias services='kg services -o wide'
alias servicesa='services -A'
alias secrets='kg secrets'
alias secretsa='secrets -A'
alias replicasets='kg replicasets -o wide -A'
alias replicasetsa='replicasets -A'
alias cluster-dump='kubectl cluster-info dump'
alias clusters='gcloud container clusters list'
alias gcompute='gcloud compute'
function cluster {
    gcloud container clusters describe --format json $1 | jq .
}

function kall-default {
    kall-iterate default
}
function kall-iterate {
    local namespace="$1"
    for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events" | sort | uniq)
    do
        echo "Resource:" $i;     kubectl -n ${namespace} get --ignore-not-found ${i}
    done
}

function kswitch {
    local new_context=$1

    cd $PIE/etc/docker/dash
    make needs-credentials APP=$new_context
    cd -
}

function __kube_ps1()
{
    # Get current context
    local CONTEXT=$(grep "current-context:" ~/.kube/config | sed "s/current-context: gke_phil-new_us-east1-b_//")

    if [ -n "$CONTEXT" ]; then
        echo "[kube:${CONTEXT}]"
    fi
}

if [ -f $HOME/.bashrc_kubectl ]; then
    source $HOME/.bashrc_kubectl
    complete -F __start_kubectl k  # from https://kubernetes.io/docs/reference/kubectl/cheatsheet/
fi


#
# HELM
#
alias hls='helm ls --all -A'
function h {
    if [ -z "$*" ]; then
        cd $PIE/.helm
        return
    fi
    helm $*
}



#
# GOOGLE GCLOUD CONTAINER METADATA
#
function metadata-query {
    curl -s "http://metadata.google.internal/computeMetadata/v1/instance/$1" -H "Metadata-Flavor: Google"
}
function metadata-tags {
    metadata-query tags
}
function metadata-disks {
    metadata-query "disks/?recursive=true"
}
function metadata-env {
    metadata-query attributes/kube-env
}
function metadata-name {
    metadata-query name
}


# RCLONE
alias rc='rclone'
alias rcl='rc ls'


# VEGGIETRONIC
alias veg-attachment='curl -v http://veggietronic-zo.$DOMAIN/static/mnt/sdcard/DCIM/slomo_1582467987_2.mov > /dev/null'
alias veg-attachment-no='curl -v http://veggietronic-zo.$DOMAIN/static/asattachment/mnt/sdcard/DCIM/slomo_1582467987_2.mov > /dev/null'

function veg {
    #
    # veg ashburn-cf ashburn-cf-2020-10-19-12-42-31.mov
    #
    camera="$1"
    filename="$2"
    crf="$3"
    threads="$4"
    preset="$5"
    profile="$6"
    port=""

    if [ -z "$crf" ]; then
        crf="28"
    fi
    if [ -z "$threads" ]; then
        threads="16"
    fi
    if [ -z "$preset" ]; then
        preset="veryfast"
    fi
    if [ -z "$profile" ]; then
        profile="main"
    fi

    if [ "$camera" == "zo" ]; then
        port=":8000"
    fi

    url="http://phil:.lyweather@veggietronic-$camera.phils.io$port/static/mnt/sdcard/DCIM/$filename?crf=$crf&threads=$threads&preset=$preset&profile=$profile&nocompress=true"

    echo "Camera: $camera"
    echo "Filename: $filename"
    echo "URL: $url"

    curl -w "@$HOME/.curl_format" -s -o "$filename" "$url"
}

# VERSIONPING
alias vp='cd ~/versionping/versionping-api'

# FFMPEG
function ffp {
    filename="$1"
    ffprobe -v quiet -print_format json -show_format -show_streams $filename | jq .
}

# GSTREAMER
export GSTREAMER_HOME=/Library/Frameworks/GStreamer.framework/Versions/1.0/
export CPATH=$GSTREAMER_HOME/include
export CPATH=$CPATH:$GSTREAMER_HOME/include/gstreamer-1.0/
export CPATH=$CPATH:$GSTREAMER_HOME/Headers
# export LIBRARY_PATH=$GSTREAMER_HOME/lib
# export GST_DEBUG=2

alias gst-basic='gst-launch-1.0 videotestsrc ! ximagesink'
alias gst-basic-osx='gst-launch-1.0 videotestsrc ! autovideosink'
alias gst-display-screen='gst-launch-1.0 avfvideosrc capture-screen=true ! autovideosink'
alias gst-webcam='gst-launch-1.0 autovideosrc device=/dev/video0 ! autovideosink'
alias gst-add-text='gst-launch-1.0 -v videotestsrc ! clockoverlay halignment=left valignment=bottom text="95.4 mph 2450" shaded-background=true font-desc="Sans, 23" ! videoconvert ! ximagesink'
alias gst-rtmp1='gst-launch-1.0 -v videotestsrc ! avenc_flv ! flvmux ! rtmpsink location="rtmp://localhost/path/to/stream" live=1'
function gst-download {
    url="$1"
    filename="$2"
    time gst-launch-1.0 -v souphttpsrc location="$url" ! filesink location="$2"
}

# VLC
alias vlc=/Applications/VLC.app/Contents/MacOS/VLC

alias v3='ssh 192.168.68.129'
alias v4='ssh 192.168.68.130'
function tp {
    server=$1
    port=$2
    nc -z -v -w 3 $server $port
}
function tpl {
    tp 127.0.0.1 $1
}
alias my='mypy --config-file $PIE/etc/setup.cfg'
function mypylint {
    filename="$1"
    pycodestyle --count --max-line-length=160 "$filename"
    mypy --config-file $PIE/etc/setup.cfg "$filename"
    pylint --rcfile $PIE/etc/.pylintrc "$filename"
}
function i {
    touch `dirname $1`/__init__.py
}

# Source
export DOTFILES_PHILLIES=${SRC_HOME}/dotfiles
[ -f $DOTFILES_PHILLIES/.bashrc ] && . $DOTFILES_PHILLIES/.bashrc

# This is included from phillies dotfiles
# [ -f $HOME/.bashrc_private ] && source $HOME/.bashrc_private

if [ -f $PIE/bin/gcp-shared.sh ]; then
    source $PIE/bin/gcp-shared.sh
fi



#
# RASPBERRY PI
#
alias rube-net='ssh zo@`arp-scan -l | grep -i "raspberry\|legra" | head -1 | cut -f1`'
alias rube-local='screen /dev/cu.usbserial 115200'
alias rube-eth='ssh pi@192.168.2.2'


# OSX
alias rosetta='arch -x86_64'
alias rb='rosetta /bin/bash'
alias notifications-enable='launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist'
alias notifications-disable='launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist; killall NotificationCenter'


# TMUX
alias tnew='tmux new -s'
alias tls='tmux ls'
alias tdet='tmux detach'
alias tat='tmux a -t'

#
#
# WIFI
#
function wifi-init {
    local airport_exe=/usr/local/bin/airport
    if [ ! -L $airport_exe ]; then
        ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport $airport_exe
        echo "Created airport symlink"
    fi
}

function wifi {
    wifi-init
    wifis=`airport -s`
    echo "$wifis" | head -1
    wifi_data=`echo "$wifis" | grep -v "SECURITY (auth/unicast/group)"`
    echo "$wifi_data" | sort -b -k 3
}

function wifi-me {
    wifi-init
    airport -I
}



#
# PYTHON
#
export FLASK_APP=main.py
export FLASK_DEBUG=1
export PYTHONPATH=$SRC_HOME
export PYTHONDONTWRITEBYTECODE=true
export MYPYPATH=$PYTHONPATH

export WHEELHOUSE="${HOME}/.cache/pip/wheelhouse"
export PIP_FIND_LINKS="file://${WHEELHOUSE}"
export PIP_WHEEL_DIR="${WHEELHOUSE}"
mkdir -p $WHEELHOUSE

# export PYTHON3_HOME=/usr/local/opt/python@3.8
# export PATH="$PYTHON3_HOME/bin:$PATH"
# export LDFLAGS="-L$PYTHON3_HOME/lib"
# export PKG_CONFIG_PATH="$PYTHON3_HOME/lib/pkgconfig"

alias python=python3

alias e='source .env/bin/activate'
alias rmp='find . -name \*.pyc | xargs rm'
# alias py='cat .ipython.py && ipython3 --no-banner --pprint -i --'
alias py='ipython3 --no-banner --pprint --no-simple-prompt -i --'
alias ac='. .env/bin/activate'
alias acc='. .env.`uname -s`/bin/activate'
alias pip='python3 -m pip'
alias pi='pip install'
alias pw='pip wheel'
alias pis='pi `grep slack $PIE/etc/requirements.txt`'
alias pir='pi -r requirements.txt'
alias env_create='pyenv virtualenv $PYENV_VERSION .env'
alias phickle='python3 $PIE/shared/phickle.py'

function pireq {
    req=$1
    local tmp=/tmp/foo
    cat requirements-prereq.txt requirements.txt > $tmp
    packages=`grep $req $tmp`
    echo
    echo
    echo $packages
    echo
    echo
    pi $packages
    rm -f $tmp
}

function findpy {
    # find . -name \*.py | grep -v "\.env\|\.git" | xargs $*
    find . -name "*.py" | grep -v "\.env\|\.git" | grep -v "{{.*}}" | xargs $*
}

function pii {
    local package=$1
    if [[ "$package" == *"=="* ]]; then
        package=`echo $package | cut -d'=' -f1`
    fi
    pip install --use-deprecated=legacy-resolver $package==
    # pip install $package==xxxxxx
}

function pl {
    local package="$1"
    local cmd="pip list"
    if [ -z "$hostname" ]
    then
        $cmd | grep -i "$package"
    else
        $cmd
    fi
}

_virtualenv_auto_activate() {
    if [ -d ".env" ]; then
        # Check to see if already activated to avoid redundant activating
        if [ "$VIRTUAL_ENV" != "$(pwd -P)/.env" ]; then
            _VENV_NAME=$(basename `pwd`)
            echo Activating virtualenv \"$_VENV_NAME\"...
            VIRTUAL_ENV_DISABLE_PROMPT=1
            source .env/bin/activate
            _OLD_VIRTUAL_PS1="$PS1"
            PS1="($_VENV_NAME) $PS1"
            export PS1
        fi
    fi
}
export PROMPT_COMMAND=_virtualenv_auto_activate


# R
alias R='R --no-save'
function rp {
    Rscript -e 'ip <- as.data.frame(installed.packages()[,c(1,3:4)]); rownames(ip) <- NULL; ip <- ip[is.na(ip$Priority),1:2,drop=FALSE]; print(ip, row.names=FALSE)' | tail -n +2 | tr -s ' ' | cut -d' ' -f2- | sort -f
}
function rp-del {
    # https://www.r-bloggers.com/how-to-remove-all-user-installed-packages-in-r/
    Rscript -e 'ip <- as.data.frame(installed.packages()); ip <- subset(ip, !grepl("MRO", ip$LibPath)); ip <- ip[!(ip[,"Priority"] %in% c("base", "recommended")),]; path.lib <- unique(ip$LibPath); pkgs.to.remove <- ip[,1]; sapply(pkgs.to.remove, remove.packages, lib = path.lib)'
}


#
# RUBY
#
alias be='bundle exec'
# alias bcap='bundle exec cap'
# alias dep='bundle exec cap prod deploy'
# source ~/.rvm/scripts/rvm
# echo 'export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"' >> ~/.zshrc
export RUBY_HOME=/opt/homebrew/opt/ruby
export PATH=$RUBY_HOME/bin:$PATH



#
# GO
#
export GOPATH=~/go

function findgo {
    find . -name \*.go | grep -v "\.env\|\.git" | xargs -I@ grep -H -i "$*" "@"
}



#
# DATADOG
#
function dogtest {
    # dogtest 10.88.0.48
    agent_location="$1"
    value="$2"

    if [ -z "$agent_location" ]; then
        agent_location="localhost"
    fi
    if [ -z "$value" ]; then
        value="1"
    fi

    statsd_line="pie.test:$value|c"
    echo "Sending $statsd_line to $agent_location"
    echo $statsd_line > /dev/udp/$agent_location/8125
    echo $?
}

#
# VMWARE
#
alias vmrun="/Applications/VMware\ Fusion.app/Contents/Public/vmrun"


# EDGERTRONIC
function edgers {
    (cd $PIE && vi video/edgertronics.yaml && cp video/edgertronics.yaml $SRC_HOME/chef/cookbooks/phillies/files/default/. )
    echo "yaml file copied to chef files"
}
function edg-status-watch {
    # from https://wiki.edgertronic.com/index.php/SDK_-_Developer_tricks
    s="" ; while sleep 0.5 ; do t=`curl http://e/get_status_string 2>/dev/null` ; if [ "$s" != "$t" ] ; then s=$t ; echo $s ; fi ; done
}

function cams {
    grep SCI $SRC_HOME/chef/cookbooks/phillies/attributes/default.rb | grep lab | tr -s ' ' | tr -d "'" | tr -d ','
}

function cam_status {
    curl -s https://${CAM_AUTH}@lab-$1.phils.io/get_camstatus | jq .
}

function cam0 {
    cam_status 0
}
function cam00 {
    cam_status 00
}

function els-all {
    path="$1"
    options="${@:2:10}"
    rclone lsf $EDGER_LAB_HOME/$path --csv --format "tsp" $options | column -t -s ' ,'
}
function els {
    path="$1"
    options="${@:2:10}"
    rclone lsf $EDGER_LAB_HOME/$path --csv --format "tsp" --include "*.mp4" $options | column -t -s ' ,'
}
function elsc {
    path="$1"
    options="${@:2:10}"
    els compressed/$path $options
}
function ecat {
    path="$1"
    arr=(${path//-/ })
    camera="${arr[0]}-${arr[1]}"
    json=${path//mp4/json}
    rclone cat $EDGER_LAB_HOME/compressed/$camera/$json | jq .
}
function eplay {
    path="$1"
    arr=(${path//-/ })
    camera="${arr[0]}-${arr[1]}"
    rclone copy $EDGER_LAB_HOME/compressed/$camera/$path /tmp/.
    open /tmp/$path
}

# GCLOUD
export CLOUDSDK_PYTHON_SITEPACKAGES=1
alias gl='gcloud beta logging'
# alias glr='gcloud logging read'

function images {
    local image="$1"
    local REPOSITORY="gcr.io/phil-new"
    if [ -z "$image" ]; then
        gcloud container images list --repository=$REPOSITORY
        return
    fi

    if [[ "$image" != "$REPOSITORY"* ]]; then
        image="$REPOSITORY/$image"
    fi

    gcloud container images list-tags $image
}

# Queries the loadbalancer logs
function glog {

    # BACKEND SERVICES
    # gcloud compute backend-services list
    # gcloud compute backend-services describe --global --format=json k8s1-18cca515-default-service-api-80-9719b3d2

    # FORWARDING RULES
    # gcloud compute forwarding-rules list
    # gcloud compute forwarding-rules describe --global --format=json k8s2-fs-dh9u9nk2-default-ingress-phillies-9ye9weet | jq .

    # HELPFUL DOCS
    # https://cloud.google.com/logging/docs/reference/v2/rest/v2/LogEntry#HttpRequest
    # https://cloud.google.com/logging/docs/logs-views
    # https://cloud.google.com/logging/docs/buckets

    # EXAMPLE LOG ENTRY FROM THE LOAD BALANCER
      # {
        # "http_request": {
          # "cache_fill_bytes": "0",
          # "cache_hit": false,
          # "cache_lookup": false,
          # "cache_validated_with_origin_server": false,
          # "latency": "0.025376s",
          # "referer": "",
          # "remote_ip": "35.196.21.140",
          # "request_method": "GET",
          # "request_size": "198",
          # "request_url": "https://papi.phils.io/schedule/near/143",
          # "response_size": "1355",
          # "server_ip": "10.88.1.139",
          # "status": 200,
          # "user_agent": "python-requests/2.25.1"
        # },
        # "insert_id": "1oi2nmwf4wj376",
        # "json_payload": {
          # "@type": "type.googleapis.com/google.cloud.loadbalancing.type.LoadBalancerLogEntry",
          # "statusDetails": "response_sent_by_backend"
        # },
        # "labels": {},
        # "log_name": "projects/phil-new/logs/requests",
        # "receive_timestamp": "2021-09-10T22:28:33.356191462Z",
        # "resource": {
          # "labels": {
            # "backend_service_name": "k8s1-18cca515-default-service-api-80-9719b3d2",
            # "forwarding_rule_name": "k8s2-fs-dh9u9nk2-default-ingress-phillies-9ye9weet",
            # "project_id": "phil-new",
            # "target_proxy_name": "k8s2-ts-dh9u9nk2-default-ingress-phillies-9ye9weet",
            # "url_map_name": "k8s2-um-dh9u9nk2-default-ingress-phillies-9ye9weet",
            # "zone": "global"
          # },
          # "type": "http_load_balancer"
        # },
        # "severity": 200,
        # "span_id": "ad5ce504c108a19d",
        # "timestamp": "2021-09-10T22:28:32.701888Z",
        # "trace": "projects/phil-new/traces/0474a1e41cfb053be0fd9c422bc292ff",
        # "trace_sampled": false
      # }

    local clause="$1"
    if [ -z "$clause" ]; then
        echo
        echo "    Please supply a clause:"
        echo '        glog tail                                          # live tail'
        echo '        glog "http_request.status = 200"                   # http successes'
        echo '        glog "http_request.status >= 400"                  # http errors'
        echo '        glog "http_request.request_method=GET"             # GET requests'
        echo '        glog "http_request.user_agent:Mozilla"             # hits by Mozilla'
        echo '        glog "http_request.remote_ip=35.196.21.140"        # hits from megacron'
        echo '        glog "http_request.request_url:schedule/near"      # hits to the schedule/near endpoint'
        echo '        glog "NOT http_request.request_url:schedule/near"  # hits NOT to the schedule/near endpoint'
        echo '        glog "timestamp <= \"2021-09-14T11:01:00.0Z\" AND timestamp >= \"2021-09-14T11:00:00.0Z\""  '  # hits during a timeperiod
        echo
        return
    fi

    local bucket=phil-log-lb
    local location=us-east1
    local resource=resource.type=http_load_balancer

    local ts_begin=receive_timestamp:label=ts-begin
    local ts_end=timestamp:label=ts-end
    local status=http_request.status
    local method=http_request.request_method:label=method
    local ip=http_request.remote_ip:label=ip
    local url=http_request.request_url:label=url
    local user_agent=http_request.user_agent:label=user-agent
    local duration=duration\(start=timestamp,end=receive_timestamp,precision=3\)
    local backend=resource.labels.backend_service_name:label=backend-service
    local forwarding=resource.labels.forwarding_rule_name:label=forwarding-rule
    local items=$ts_begin,$ts_end,$duration,$status,$method,$backend,$forwarding,$ip,$url,$user_agent

    local sep=','
    # sep="\\t"
    local format="csv[separator='$sep']"
    local format_arg="$format($items)"

    if [ "$clause" = "tail" ]; then

        # Tails the live loadbalancer log from stackdriver
        gcloud alpha logging tail \
            $resource \
            --format="$format_arg"
            # --buffer-window=1s \

        return
    fi

    # Reads the logging bucket
    gcloud logging read \
        --bucket=$bucket --location=$location \
        --format="$format_arg" \
        --view=lb-all \
        "$resource AND $clause"
}

function glog-errors {
    glog "http_request.status >= 400"
}

function glog-net {
    # glog-net 10.142.0.55
    # Tails the log, looking for australia connections to prod-lb-2

    # NOTE: Not all log entries are identical - they vary in their json_payload!
    # A couple examples are below:

    #
    # EXAMPLE LOG ENTRY FROM THE VPC FLOW LOG:
    #
    # insert_id: lnfc9wfsnlqnr
    # json_payload:
        # bytes_sent: '0'
        # connection:
            # dest_ip: 10.142.0.55
            # dest_port: 59748.0
            # protocol: 6.0
            # src_ip: 10.142.0.14
            # src_port: 81.0
        # dest_instance:
            # project_id: phil-new
            # region: us-east1
            # vm_name: prod-lb-2
            # zone: us-east1-b
        # dest_vpc:
            # project_id: phil-new
            # subnetwork_name: default
            # vpc_name: default
        # end_time: '2022-02-26T00:38:56.801628410Z'
        # packets_sent: '32'
        # reporter: SRC
        # src_instance:
            # project_id: phil-new
            # region: us-east1
            # vm_name: prod-box-1
            # zone: us-east1-b
        # src_vpc:
            # project_id: phil-new
            # subnetwork_name: default
            # vpc_name: default
        # start_time: '2022-02-26T00:38:56.801628410Z'
    # labels: {}
    # log_name: projects/phil-new/logs/compute.googleapis.com%2Fvpc_flows
    # receive_timestamp: '2022-02-26T00:39:06.260415192Z'
    # resource:
        # labels:
            # location: us-east1-b
            # project_id: phil-new
            # subnetwork_id: '2966778331651493890'
            # subnetwork_name: default
        # type: gce_subnetwork
    # severity: 0
    # span_id: ''
    # timestamp: '2022-02-26T00:39:06.260415192Z'
    # trace: ''
    # trace_sampled: false

    #
    # THIS EXAMPLE HAS DEST_GKE_DETAILS:
    #
    # insert_id: v32pezfspm26f
    # json_payload:
        # bytes_sent: '12672'
        # connection:
            # dest_ip: 10.48.10.7
            # dest_port: 53.0
            # protocol: 17.0
            # src_ip: 10.48.14.4
            # src_port: 37597.0
        # dest_gke_details:
            # cluster:
            # cluster_location: us-east1-b
            # cluster_name: us-east1-pie-d40432e2-gke
            # pod:
            # pod_name: kube-dns-7f4d6f474d-xzfnt
            # pod_namespace: kube-system
            # service:
            # - service_name: kube-dns
            # service_namespace: kube-system
        # dest_instance:
            # project_id: phil-new
            # region: us-east1
            # vm_name: gke-us-east1-pie-d40-nodepool-airflow-15e689e0-00sg
            # zone: us-east1-b
        # dest_vpc:
            # project_id: phil-new
            # subnetwork_name: default
            # vpc_name: default
        # end_time: '2022-02-26T00:39:02.801958676Z'
        # packets_sent: '128'
        # reporter: DEST
        # src_gke_details:
            # cluster:
            # cluster_location: us-east1-b
            # cluster_name: us-east1-pie-d40432e2-gke
            # pod:
            # pod_name: airflow-scheduler-6d9f76664f-gppx2
            # pod_namespace: composer-1-16-15-airflow-1-10-15-d40432e2
        # src_instance:
            # project_id: phil-new
            # region: us-east1
            # vm_name: gke-us-east1-pie-d40432e-default-pool-8e49d417-yx6c
            # zone: us-east1-b
        # src_vpc:
            # project_id: phil-new
            # subnetwork_name: default
            # vpc_name: default
        # start_time: '2022-02-26T00:39:02.801958676Z'
    # labels: {}
    # log_name: projects/phil-new/logs/compute.googleapis.com%2Fvpc_flows
    # receive_timestamp: '2022-02-26T00:39:06.591510802Z'
    # resource:
        # labels:
            # location: us-east1-b
            # project_id: phil-new
            # subnetwork_id: '2966778331651493890'
            # subnetwork_name: default
        # type: gce_subnetwork
    # severity: 0
    # span_id: ''
    # timestamp: '2022-02-26T00:39:06.591510802Z'
    # trace: ''
    # trace_sampled: false`

    # THIS EXAMPLE HAS DEST_LOCATION:
    # insert_id: tosr7afjhafxr
    # json_payload:
        # bytes_sent: '1300'
        # connection:
            # dest_ip: 34.73.91.160
            # dest_port: 443.0
            # protocol: 6.0
            # src_ip: 10.142.0.8
            # src_port: 51748.0
        # dest_location:
            # asn: 15169.0
            # continent: America
            # country: usa
        # end_time: '2022-02-26T00:39:04.334656719Z'
        # packets_sent: '8'
        # reporter: SRC
        # rtt_msec: '11'
        # src_gke_details:
            # cluster:
            # cluster_location: us-east1-b
            # cluster_name: blockhead-cluster
        # src_instance:
            # project_id: phil-new
            # region: us-east1
            # vm_name: gke-blockhead-cluster-default-pool-09d3a8c5-ifnp
            # zone: us-east1-b
        # src_vpc:
            # project_id: phil-new
            # subnetwork_name: default
            # vpc_name: default
        # start_time: '2022-02-26T00:39:02.476456466Z'
    # labels: {}
    # log_name: projects/phil-new/logs/compute.googleapis.com%2Fvpc_flows
    # receive_timestamp: '2022-02-26T00:39:14.250142254Z'
    # resource:
        # labels:
            # location: us-east1-b
            # project_id: phil-new
            # subnetwork_id: '2966778331651493890'
            # subnetwork_name: default
        # type: gce_subnetwork
    # severity: 0
    # span_id: ''
    # timestamp: '2022-02-26T00:39:14.250142254Z'
    # trace: ''
    # trace_sampled: false

    ip="$1"

    local sep=','
    local format="csv[separator='$sep']"

    local insert_id=insert_id
    local bytes_sent=json_payload.bytes_sent
    local src_ip=json_payload.connection.src_ip
    local src_port=json_payload.connection.src_port
    local dest_ip=json_payload.connection.dest_ip
    local dest_port=json_payload.connection.dest_port
    local protocol=json_payload.connection.protocol
    local timestamp=timestamp
    local dest_country=json_payload.dest_location.country
    local src_vm=json_payload.src_instance.vm_name
    local dest_vm=json_payload.dest_instance.vm_name

    local items=$timestamp,$bytes_sent,$src_ip,$src_port,$dest_ip,$dest_port,$protocol,$src_vm,dest_vm,$dest_country,$insert_id

    local format_arg="$format($items)"
    local resource="resource.type=gce_subnetwork"

    if [ -z $ip ]; then
        echo
        echo Tailing ALL ip addresses!
        echo To tail a single box, run 'glog-net 10.142.0.55'
        echo Use the internal IP address of the box
        echo To get a list of internal IPs, run 'gcloud compute instances list'
        echo
    else
        echo
        echo Tailing traffic to/from $ip
        echo
        resource="$resource AND (json_payload.connection.src_ip=$ip OR json_payload.connection.dest_ip=$ip)"
    fi

    gcloud beta logging tail \
        "$resource" \
        --format="$format_arg"
}


function bucket-logs {
    local dir="~/logs"
    local bucket="gs://phil-logs"
    local file_prefix="access-log-"

    # get all the files
    mkdir -p $dir
    rm -rf $dir
    cd $dir
    gsutil rsync $bucket/$file_prefix* .
    # gsutil rsync $bucket .

    # remove the ==> header line from any files that have it
    for filename in $file_prefix*; do
        grep -v "==>" $filename  > tmp
        mv tmp $filename
    done

    # save the header from one of the files
    local one_file=`ls -a | head -4 | tail -1`
    head -1 $one_file > header

    # remove the header from all the files
    for filename in $file_prefix*; do
        sed 1d $filename > foo
        mv foo $filename
    done

    # cat all the files together
    rm -f output.csv
    cat header $file_prefix* > output.csv
}

function check-cluster-ips {
    local clusters=`gcloud container clusters list | grep -v MASTER_IP`
    echo
    echo "$clusters"
    echo
    local ips=`echo "$clusters" | tr -s ' ' | cut -d' ' -f4`
    for ip in $ips; do
        echo "Checking $ip"
        local url="https://$ip/api/v1/pods"
        local response=`curl -s -k $url | jq .code` 
        if [ "$response" == "403" ]; then
            echo "Got a 403 response. Good!"
        else
            echo "Got a $code response. NOT GOOD!"
        fi
        echo
    done
}

function datalab {
  gcloud compute ssh --quiet \
  --project $PHIL_GCLOUD_PROJECT \
  --zone $PHIL_GCLOUD_ZONE \
  --ssh-flag="-N" \
  --ssh-flag="-L" \
  --ssh-flag="localhost:8081:localhost:8080" \
  "zo@prod-datalab-1"
}


#
# SSH
#
# alias mega='ssh megacron.phils.io'
# alias meg='mega'
alias lb="p lb-2"
alias lbv='ssh lbvideo.phils.io'
function g-ssh {
    gcompute ssh --project $PHIL_GCLOUD_PROJECT --zone $PHIL_GCLOUD_ZONE $1
}
function g-list {
    # knife google server list --gce-project $PHIL_GCLOUD_PROJECT --gce-zone $PHIL_GCLOUD_ZONE_1
    gcompute instances list | grep RUNNING | sort
}
function g-list2 {
    knife google server list --gce-project $PHIL_GCLOUD_PROJECT --gce-zone $PHIL_GCLOUD_ZONE_2
}
function s {
    # . ~/.bashrc
    # local ip=`knife google server list  | grep -v terminated | grep $1 | tr -s ' ' | cut -d ' ' -f5`
    local ip=`gcloud compute instances list  | grep -v TERMINATED | grep $1 | tr -s ' ' | cut -d ' ' -f5`
    ssh $ip
}
function p {
    local ip=`gcloud compute instances list  | grep -v TERMINATED  | grep prod | tr -s ' ' | cut -d' ' -f1,5 | grep $1 | sort -n | head -1 | cut -d' ' -f2`
    ssh $ip
}


# LIBICU
export PATH="/usr/local/opt/icu4c/bin:/usr/local/opt/icu4c/sbin:$PATH"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/opt/icu4c/lib/pkgconfig"


#
# VIDEO
#
function vid-180 {
    vid-transpose "$1" "transpose=2,transpose=2"
}
function vid-90-clockwise {
    vid-transpose "$1" "transpose=1"
}
function vid-90-counterclockwise {
    vid-transpose "$1" "transpose=2"
}
function vid-transpose {
    source="$1"
    output="$source-flipped.mov"
    transpose="$2"
    ffmpeg -hide_banner -i "$source" -vf "$transpose" "$output"
    echo
    echo
    echo "New video saved to: '$output'"
}
function vid-copy {
    scp $1 zo@35.196.143.249:/mnt/videos/edgertronic-test/.
}
function vid-noaudio {
    filepath=$1
    filename=$(basename -- "$filepath")
    extension="${filename##*.}"
    filename="${filename%.*}"
    time ffmpeg -hide_banner -y -i $filepath -c copy -an $filename-xx.$extension
}
# OSX:
# original: 112321631 bytes
# HandBrakeCli 12446540 bytes, 17.0 seconds on osx
# ffmpeg 17:   37824304 bytes, 19.6 seconds on osx
# ffmpeg 23:   10222457 bytes, 13.1 seconds on osx
# ffmpeg 30:    3968933 bytes, 11.5 seconds on osx
# ffmpeg 17:   37793868 bytes, 289 seconds on prod-video-4
# ffmpeg 30:    3966501 bytes, 168 seconds on prod-video-4
function vid-compress-ffmpeg {
    filepath=$1
    filename=$(basename -- "$filepath")
    extension="${filename##*.}"
    filename="${filename%.*}"

    quality=28
    time ffmpeg -hide_banner -y -i $filepath -crf $quality $filename-y-$quality.$extension
}
function vid-compress-handbrake {
    filepath=$1
    filename=$(basename -- "$filepath")
    extension="${filename##*.}"
    filename="${filename%.*}"
    time HandBrakeCLI -O -i $filepath -o $filename-x.$extension
}
function tele {
    telnet `arp-scan -l | grep "00:1b:c5:09:65:94" | cut -f1`
}
function bp1 {
    ssh 192.168.1.56
    # ssh-mac dc:a6:32:38:8b:fd
}
function pihole {
    ssh-mac b8:27:eb:8f:90:0c
}
function veg1 {
    ssh-mac 00:d8:61:d7:22:04
}
function crapsodo {
    ssh-mac dc:a6:32:38:8b:2b
}
function crapsodo2 {
    ssh-mac dc:a6:32:38:8b:2a
}
function mac-ip {
    local mac=$1
    ip=`arps | grep "$mac" | head -1 | tr -s '\t' ' ' | cut -d' ' -f1`
    echo $ip
}
function ssh-mac {
    local mac=$1
    echo "SSHing into MAC: $mac"
    local ip=`mac-ip $mac`
    echo "SSHing into IP:  $ip"
    echo ""
    ssh `mac-ip $mac`
}
function arps {
    if [ $# -eq 0 ]; then
        interface="en0"
    else
        interface="$1"
    fi

    # expand sets the tab stops to be at precise locations
    output=`arp-scan --macfile=/usr/local/share/arp-scan/mac-override.txt -l --plain --ignoredups --interface $interface | sort -b -k3,3 -k2,2`
    echo "$output" | expand -t 16,36
}

# alias arps1='arps | sort -t . -k1,1n -k2,2n -k3,3n -k4,4n '  # -t is the separator, treat all 4 octets as numbers
# alias arps2='arps | sort -b -k2,2'  # -b meaans to ignore leading blanks
# alias arps3='arps | sort -k3,3f -k4,4f -k5,5f -k1,1n'

function arps1 {
    arps $1 | sort -t . -k1,1n -k2,2n -k3,3n -k4,4n  # -t is the separator, treat all 4 octets as numbers
}
function arps2 {
    arps $1 | sort sort -b -k2,2  # -b meaans to ignore leading blanks
}
function arps3 {
    arps $1 | sort -k3,3f -k4,4f -k5,5f -k1,1n
}

function macs {
    local file=/usr/local/share/arp-scan/mac-override.txt
    vi $file
    echo
    echo "  MACs: https://docs.google.com/spreadsheets/d/13ZjWn1mXnx0M_FC2YFWNiV8Aw9hC4Ewh5sLn92ePG9k/edit"
    echo "  Orbi: http://192.168.1.1/start.htm"
    echo
    cp -f $file $file.bak
    cp $file ~/Dropbox/arp-scan/.
}

function mac-name {
    # Returns the "name" of the computer with the passed-in MAC
    local file=/usr/local/share/arp-scan/mac-override.txt
    local mac="$1"
    mac=`echo $mac | tr -d ':'`

    # if we dont have a mac addr
    if [ -z "$mac" ]; then
        echo "Unknown MAC"
        return
    fi

    name=`grep -i $mac $file | tr '\t' ' ' | tr -s ' ' | cut -d' ' -f2-`
    if [ -z "$name" ]; then
        echo "Unknown MAC"
        return
    fi

    echo $name
}

function orbi {
    stuff=`curl -s \
        "$ORBI_DEVICES_URL" \
        -X POST \
        -H 'Accept: */*' \
        -H 'Accept-Language: en-US,en;q=0.5' \
        -H 'Accept-Encoding: gzip, deflate' \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -H 'X-Requested-With: XMLHttpRequest' \
        -H 'Origin: http://192.168.1.1' \
        -H 'DNT: 1' \
        -H '$ORBI_AUTH' \
        -H 'Connection: keep-alive' \
        -H 'Referer: http://192.168.1.1/DEV_device2.htm' \
        -H '$ORBI_COOKIE' \
        -H 'Sec-GPC: 1' \
        --data-raw 'count=1'`

    # echo "$stuff" | jq .devices
    stuff=`echo "$stuff" | sed "s/5 GHz/5GHz/g" | sed "s/2.4 GHz/2.4GHz/g"`
    # echo "$stuff" | jq -r '.devices[] | [.ip, .mac, .connectionType, .name] | @tsv' | expand -t 16,36,44
    echo "$stuff" | jq -r '.devices[] | [.ip, .mac, .connectionType, .name] | @tsv' | tabulate --format plain
}

alias orbi1='orbi | sort -t . -k1,1n -k2,2n -k3,3n -k4,4n '  # -t is the separator, treat all 4 octets as numbers
alias orbi2='orbi | sort -b -k2,2'  # -b meaans to ignore leading blanks
alias orbi3='orbi | sort -k3,3f -k4,4f -k5,5f -k1,1n'
alias orbi4='orbi | sort -k4,4f -k3,3f'


function arps-all {
    arps_output=`arps1`
    orbi_output=`orbi1`

    echo
    echo "ARP scan:"
    echo "$arps_output"
    echo
    echo "ORBI router scan:"
    echo "$orbi_output"
    echo

    # get the MAC addresses from both lists
    macs_arps=`echo "$arps_output" | tr -s ' ' | cut -d' ' -f2 | sort | tr '[:upper:]' '[:lower:]'`
    macs_orbi=`echo "$orbi_output" | tr -s ' ' | cut -d' ' -f2 | sort | tr '[:upper:]' '[:lower:]'`

    # see which MACS are in orbi that ARENT in arps output
    echo "$macs_arps" > /tmp/macs_arps.txt
    echo "$macs_orbi" > /tmp/macs_orbi.txt

    echo
    echo "Only found in arps:"
    only_in_arps=`comm -23 /tmp/macs_arps.txt /tmp/macs_orbi.txt`
    for mac in $only_in_arps; do
        echo "$arps_output" | grep -i "$mac"
    done
    echo

    echo "Only found in Orbi:"
    only_in_orbi=`comm -13 /tmp/macs_arps.txt /tmp/macs_orbi.txt`
    for mac in $only_in_orbi; do
        known_name=`mac-name $mac`

        orbi_line=`echo "$orbi_output" | grep -i "$mac" | tr -s ' '`

        ip=`echo $orbi_line | cut -d' ' -f1`
        conn=`echo $orbi_line | cut -d' ' -f3`
        orbi_name=`echo $orbi_line | cut -d' ' -f4`

        echo -e "$ip\t$mac\t$conn\t$known_name ($orbi_name)" | expand -t 16,36,44
    done

    echo
}



#
# PIHOLE
#

function pihole-ip {
    # Gets the IP address of the pihole
    local mac="b8:27:eb:8f:90:0c"
    # ip=`arps | grep "$mac" | head -1 | tr -s '\t' ' ' | cut -d' ' -f1`
    local ip=192.168.1.2
    echo $ip
}

function pihole-cmd {
    # Runs a command on the pihole
    # echo "Getting IP..."
    local ip=`pihole-ip`
    # echo "IP is: $ip"
    local cmd="$1"
    ssh -o LogLevel=QUIET -t $ip "sudo su -c '$cmd'"
}

function pihole-cmd-piholer {
    # Runs the piholer.sh script on the box, which does stuff
    local ip=`pihole-ip`
    ssh -o LogLevel=QUIET -t $ip "./piholer.sh $*"
}

function pihole-tail {
    # Tails the pihole log
    local cmd="pihole tail"
    pihole-cmd "$cmd"
}

function pihole-history {
    # Gets the history of an IP address
    local ip=$1
    pihole-cmd-piholer history $ip
    echo
    echo "It is now: `utc`"
    echo
}

function pihole-history-and-tail {
    # MAC: C8:58:C0:ED:91:DA
    local ip=$1

    # make an array of domains to ignore in the output. Internet detritus, just dont want to see it
    declare -a ignored_domains
    ignored_domains=()
    ignored_domains+=("clients6.google.com" "googleusercontent.com" "googleapis.com" "gstatic.com" "pki.goog" "ytimg.com" "ggpht.com")
    ignored_domains+=("cloudfront.net" "amazonaws.com")
    ignored_domains+=("icloud.com" "apple.com" "apple-dns.net" "icloud-content.com" "mzstatic.com" "aaplimg.com" "apple.news")
    ignored_domains+=("akamaiedge.net" "akadns.net" "sc-cdn.net")
    ignored_domains+=("twimg.com" "firebaseio.com" "digicert.com")
    ignored_domains+=("HTTPS")

    # get length of an array
    length=${#ignored_domains[@]}

    # add each item in the array to the ignored_string
    ignored_string=""
    for (( i=0; i<length; i++ )); do
        domain="${ignored_domains[$i]}"
        # printf "Current index %d with value %s\n" $i "$domain"
        ignored_string+="$domain"
        # echo "xxx 1: $ignored_string"

        # if its not the last item, add the separator
        if [[ $i -lt $(($length-1)) ]]; then
            # echo "adding sep"
            ignored_string+="\|"
            # echo "xxx 2: $ignored_string"
        fi
    done

    # escape the periods
    escaped_ignored_string=${ignored_string/\./\\\.}

    # run the command, grep out the ignored domains
    pihole-history $ip | grep -v "$escaped_ignored_string"

    echo "Tailing log"
    pihole-tail | grep --line-buffered $ip
}

function pihole-tail-device {
    local name="$1"

    echo "Finding devices..."
    local devices=`arps3 | grep -i "${name}"`
    echo
    echo "Found devices:"
    echo "${devices}"
    echo

    local ip=`echo "${devices}" | head -1 | cut -d' ' -f1`
    echo "${ip} Choosing the first device"
    pihole-tail | grep --line-buffered $ip
}

function pihole-chromebook {
    pihole-history-and-tail 192.168.1.234  # MAC: C8:58:C0:ED:91:DA
}

function pihole-quicyphone {
    pihole-history-and-tail 192.168.1.235  # MAC: 9a:5c:74:f9:9f:b7
}

function pihole-ipad {
    pihole-history-and-tail 192.168.1.170  # MAC: ca:16:ad:48:20:97
}

function pihole-appletv-outside {
    pihole-history-and-tail 192.168.1.109  # MAC: f0:b3:ec:48:06:10
}

function pihole-appletv-tvroom {
    pihole-history-and-tail 192.168.1.240  # MAC: a8:51:ab:00:68:f6
}

function pihole-tv-livingroom {
    pihole-history-and-tail 192.168.1.131  # MAC: 64:07:f6:91:c4:a4
}

function pihole-tv-tvroom {
    pihole-history-and-tail 192.168.1.105  # MAC: 70:97:41:2c:ca:ca
}

function pihole-tv-office {
    pihole-history-and-tail 192.168.1.216  # MAC: 34:f1:50:3c:8a:5e
}

function pihole-tv-outside {
    pihole-history-and-tail 192.168.1.176  # d0:c2:4e:db:37:94
}

function pihole-tv-roku-bedroom {
    pihole-history-and-tail 192.168.1.151  # 08:05:81:c9:17:4d
}

function pihole-nintendo-switch {
    pihole-history-and-tail 192.168.1.174  # 74:84:69:89:c3:11
}

function pihole-xbox {
    pihole-history-and-tail 192.168.1.146  # 2c:54:91:76:40:2d
}

function pihole-tonal {
    pihole-history-and-tail 192.168.1.143  # MAC: 10:59:17:03:09:a7
}


function pihole-domains {
    limit="$1"
    if [ -z "$limit" ]; then
        limit=100
    fi
    pihole-cmd-piholer domains $limit
}

function pihole-up {
    pihole-cmd-piholer up
}




function dev {
    #
    # Either tails or looks in history for a device
    #
    if [ -z "$1" ]; then
        arps
        echo
        echo "  Please choose a device!"
        echo
        return
    fi

    pattern="$1"
    echo "Discovering '$pattern'"

    devices=`arps | grep "$pattern"`
    if [ -z "$devices" ]; then
        arps
        echo
        echo "  No matching devices found. Bailing"
        echo
        return
    fi

    count=`echo "$devices" | wc -l`
    echo "Discovered "$count" device(s):"
    echo "$devices"

    device=`echo "$devices" | head -1 | tr -s '\t' ' '`
    name=`echo "$device" | cut -d' ' -f3-`
    echo "Choosing first: '$name'"

    mac=`echo "$device" | cut -d' ' -f2`
    echo "'$name' MAC: $mac"

    ip=`echo "$device" | cut -d' ' -f1`
    echo "'$name' IP:  $ip"


    # get historical info
    # SQLITE SCHEMA: https://docs.pi-hole.net/database/ftl/
    # SQLITE CLI: https://www.sqlite.org/cli.html
    echo
    echo "Querying sqlite..."

    #
    # This is the SQL in human-readable form
    #
    #  SELECT datetime(timestamp, 'unixepoch') AS datetime,
    #  CASE status
    #    WHEN '2'  THEN 'ok'
    #    WHEN '3'  THEN 'ok'
    #    WHEN '12' THEN 'ok'
    #    WHEN '13' THEN 'ok'
    #    WHEN '14' THEN 'ok'
    #    ELSE 'blocked'
    #    END blocked,
    # domain,
    # CASE type
    #     WHEN 1  THEN 'A'
    #     WHEN 2  THEN 'AAAA'
    #     WHEN 3  THEN 'ANY'
    #     WHEN 4  THEN 'SRV'
    #     WHEN 5  THEN 'SOA'
    #     WHEN 6  THEN 'PTR'
    #     WHEN 7  THEN 'TXT'
    #     WHEN 8  THEN 'NAPTR'
    #     WHEN 9  THEN 'MX'
    #     WHEN 10 THEN 'DS'
    #     WHEN 11 THEN 'RRSIG'
    #     WHEN 12 THEN 'DNSKEY'
    #     WHEN 13 THEN 'NS'
    #     WHEN 14 THEN 'OTHER (any query type not covered elsewhere)'
    #     WHEN 15 THEN 'SVCB'
    #     WHEN 16 THEN 'HTTPS'
    #     ELSE 'Unknown'
    #     END type_string
    # FROM queries
    # WHERE client = '192.168.1.151'
    # ORDER BY datetime ASC
    # LIMIT 10;

    #
    # This is the SQL all on one line. Took too long to get a HEREDOC working in bash, so this is what it is
    #
    sql="SELECT datetime(timestamp, 'unixepoch') AS datetime, CASE status WHEN '2' THEN 'ok' WHEN '3' THEN 'ok' WHEN '12' THEN 'ok' WHEN '13' THEN 'ok' WHEN '14' THEN 'ok' ELSE 'blocked' END blocked, domain, type FROM queries WHERE client = '$ip' ORDER BY datetime DESC;"

    sqlite3 -header -cmd ".mode box" /etc/pihole/pihole-FTL.db "$sql"

    # then tail
    echo
    echo "Tailing log file..."
    # tail -10000f /var/log/pihole.log | grep "$ip"
    pihole tail | grep --line-buffered "$ip"
}



#
# DATABASE
#
function phil-db-setadmin {
    export PHIL_GCLOUD_DB_UP_USER=$PHIL_GCLOUD_DB_ADMIN_USER
    export PHIL_GCLOUD_DB_UP_PW=$PHIL_GCLOUD_DB_ADMIN_PW
}
function phil-db-local {
    mycli --port 3306 -h 127.0.0.1 -u$PHIL_DOCKER_DB_USER -p$PHIL_DOCKER_DB_PW "$@"
}
function phil-db-proxy {
    mycli --port 3406 -h 127.0.0.1 -u$PHIL_GCLOUD_DB_UP_USER -p$PHIL_GCLOUD_DB_UP_PW $@
}
function phil-db {
    mycli -h $PHIL_GCLOUD_DB_IP $PHIL_GCLOUD_DB_NAME -u $PHIL_GCLOUD_DB_USER -p$PHIL_GCLOUD_DB_PW "$@"
}
function phil-db-admin {
    mycli -h $PHIL_GCLOUD_DB_IP $PHIL_GCLOUD_DB_NAME -u $PHIL_GCLOUD_DB_ADMIN_USER -p$PHIL_GCLOUD_DB_ADMIN_PW "$@"
}
function phil-db-uploader {
    mycli -h $PHIL_GCLOUD_DB_IP $PHIL_GCLOUD_DB_NAME -u $PHIL_GCLOUD_DB_UP_USER -p$PHIL_GCLOUD_DB_UP_PW "$@"
}
function phil-db-dev {
    mycli -h $PHIL_GCLOUD_DB_IP_DEV phil_data -u $PHIL_GCLOUD_DB_USER -p$PHIL_GCLOUD_DB_PW "$@"
}
function phil-db-staging {
    mycli -h 104.196.190.222 phil_data -u $PHIL_GCLOUD_DB_USER -p$PHIL_GCLOUD_DB_PW "$@"
}
function phil-db-clone {
    mycli -h $PHIL_GCLOUD_DB_CLONE_IP $PHIL_GCLOUD_DB_NAME -u $PHIL_GCLOUD_DB_USER -p$PHIL_GCLOUD_DB_PW "$@"
}

function ls-backups {
    gsutil ls -lh $PHIL_GCLOUD_BUCKET/daily/
}
function ls-backups2 {
    gsutil ls -lh $PHIL_GCLOUD_BUCKET/daily/phil_data/
}
function restore-latest-backup {
    pushd .
    cd $SRC_HOME
    mkdir -p backups
    cd backups

    # gsutil cp `gsutil ls -lh $PHIL_GCLOUD_BUCKET/fullschema | grep daily | tail -1 | tr -s ' ' | cut -d' ' -f5` fullschema.sql.gz
    # gzip -d fullschema.sql.gz

    gsutil cp `gsutil ls -lh $PHIL_GCLOUD_BUCKET/daily/ | grep backup_ | tail -1 | tr -s ' ' | cut -d' ' -f5` backup.sql.gz
    rm -f backup.sql
    echo "Decompressing..."
    gzip -d backup.sql.gz

    mysql -uroot -p$PHIL_GCLOUD_DB_PW -e "DROP DATABASE phil_data"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -e "CREATE DATABASE phil_data"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -e "RESET MASTER"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -e "UPDATE mysql.user SET Super_Priv='Y' WHERE user='root' AND host='%'"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -e "SET autocommit=0;"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -e "SET unique_checks=0;"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -e "SET foreign_key_checks=0;"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -e "FLUSH PRIVILEGES"

    pv backup.sql | mysql -uroot -p$PHIL_GCLOUD_DB_PW phil_data
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -e "COMMIT;"
    popd
}

function restore-latest-backup-dev {
    # pushd .
    # cd $SRC_HOME
    # mkdir -p backups
    # cd backups

    # gsutil cp `gsutil ls -lh $PHIL_GCLOUD_BUCKET/daily/ | grep backup_ | tail -1 | tr -s ' ' | cut -d' ' -f5` backup.sql.gz
    # rm -f backup.sql
    # echo "Decompressing..."
    # gzip -d backup.sql.gz

    mysql -uroot -p$PHIL_GCLOUD_DB_PW -h$PHIL_GCLOUD_DB_IP_DEV -e "DROP DATABASE phil_data"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -h$PHIL_GCLOUD_DB_IP_DEV -e "CREATE DATABASE phil_data"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -h$PHIL_GCLOUD_DB_IP_DEV -e "RESET MASTER"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -h$PHIL_GCLOUD_DB_IP_DEV -e "UPDATE mysql.user SET Super_Priv='Y' WHERE user='root' AND host='%'"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -h$PHIL_GCLOUD_DB_IP_DEV -e "SET autocommit=0;"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -h$PHIL_GCLOUD_DB_IP_DEV -e "SET unique_checks=0;"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -h$PHIL_GCLOUD_DB_IP_DEV -e "SET foreign_key_checks=0;"
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -h$PHIL_GCLOUD_DB_IP_DEV -e "FLUSH PRIVILEGES"

    pv backup.sql | mysql -uroot -p$PHIL_GCLOUD_DB_PW -h$PHIL_GCLOUD_DB_IP_DEV phil_data
    mysql -uroot -p$PHIL_GCLOUD_DB_PW -h$PHIL_GCLOUD_DB_IP_DEV -e "COMMIT;"
    popd
}

# function gdb-add-ip {
    # alias gdb-ip-add='time gdb patch $PHIL_GCLOUD_DB_INSTANCE --authorized-networks'
# }


#
# GCLOUD
#
alias gcluster='gcloud container clusters'
alias gcl='gcluster'
alias sshg='gcloud compute ssh'
alias gql='gcloud beta sql'
alias gdb='gcloud sql instances'
alias gdbs='gdb list'
alias gpub='gcloud pubsub'
alias gtopic='gpub topics'
alias gsub='gpub subscriptions'
# export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/legacy_credentials/$PHIL_GCLOUD_DB_USER_EMAIL/adc.json
export GOOGLE_APPLICATION_CREDENTIALS=~/google-service-account.json

function lsg {
    gsutil ls -l gs://$1
}
function lsv {
    lsg phil-videos/$1
}

# GOOGLE GCLOUD DNS
export CLOUDSDK_PYTHON=/usr/local/bin/python3
alias dnsrecon='python3 ~/phillies/dnsrecon/dnsrecon.py'
alias dnsenum='docker run -it -v "$PWD":/tmp -w /tmp perl:5.34 perl dnsenum.sh'
alias dns='gcloud dns'
alias dns-transaction='dns record-sets transaction'
alias dns-list-all='dns record-sets list --zone $DNS_ZONE'
function dns-list {
    dns-list-all --name $1.$DOMAIN_FQ
}
function dns-create {
    local name=$1.$DOMAIN_FQ
    local ip=$2

    rm -f transaction.yaml
    dns-transaction start --zone=$DNS_ZONE

    dns-transaction add \
        --name $name \
        --ttl 10 \
        --type A \
        $ip \
        --zone=$DNS_ZONE

    # dns-transaction describe --zone=$DNS_ZONE
    dns-transaction execute --zone=$DNS_ZONE
}
function dns-delete {
    local name=$1.$DOMAIN_FQ

    local record=`dns-list $1 | grep -v DATA`
    local type=`echo $record | cut -d' ' -f2`
    local ttl=`echo $record | cut -d' ' -f3`
    local ip=`echo $record | cut -d' ' -f4`

    rm -f transaction.yaml
    dns-transaction start --zone=$DNS_ZONE

    dns-transaction remove \
        --name $name \
        --ttl $ttl \
        --type $type \
        $ip \
        --zone=$DNS_ZONE

    # dns-transaction describe --zone=$DNS_ZONE
    dns-transaction execute --zone=$DNS_ZONE
}
function dns-exists {
    dns-list $1 > /dev/null 2>&1
}


#
# GOOGLE GCLOUD DNS
#
function gdns {
    arg="$1"
    if [ -z "$arg" ]; then
        echo
        echo "  Please supply an arg:"
        echo "    add - adds an entry"
        echo "    del - deletes an entry"
        echo "    ls - lists entries"
        echo "    mv - moves an entry (deletes then adds)"
        echo
    fi
    if [ "$arg" == "add" ]; then
        gdns-add $*
    elif [ "$arg" == "del" ]; then
        gdns-del $*
    elif [ "$arg" == "ls" ]; then
        gdns-ls $*
    elif [ "$arg" == "mv" ]; then
        gdns-mv $*
    fi
}
function gdns-add-all {
    #
    # gdns-add-all a b c d foobar
    #
    target=" ${@: -1}"
    echo "Target is $target"

    unset "$@[-1]"

    for var in "$@"
    do
        echo "ARG is $var"
    done
}
function gdns-add {
    #
    # gdns-add foo 34.73.92.181
    # gdns-add foo bar 5
    #
    local hostname="$1"     # "foobar.$DOMAIN_FQ"
    local target="$2"       # "127.0.0.1"
    local ttl="$3"          # in seconds

    if [ -z "$hostname" ]; then
        echo
        echo "  gdns-add foo 127.0.0.1          # will make foo an A"
        echo "  gdns-add foo 127.0.0.1 5        # will make foo an A with a TTL of 5 seconds"
        echo "  gdns-add foo bar                # will make foo a CNAME to bar.$DOMAIN_FQ"
        echo
        return
    fi

    if [ -z "$ttl" ]; then
        ttl="60"
    fi

    if [[ "$hostname" != *$DOMAIN ]]; then
        hostname="$hostname.$DOMAIN_FQ"
    fi


    local target_no_dots=`echo $target | tr -d '.'`
    if [[ "$target_no_dots" =~ ^[[:digit:]]*$ ]]; then
        record_type="A"
        echo "    DNS Detected IP address for target"
    else
        record_type="CNAME"

        # Is the target a FQDN with a dot at the end? If so, dont append our domain
        if [[ "$target" =~ \.$ ]]; then
            echo "    DNS detected FQDN for target"
        else
            target="$target.$DOMAIN_FQ"
        fi
    fi

    echo
    echo "    DNS hostname:       $hostname"
    echo "    DNS target:         $target"
    echo "    DNS ttl:            $ttl seconds"
    echo "    DNS record type:    $record_type"
    echo

    local ttl="--ttl=$ttl"
    local gdns="gcloud dns record-sets transaction"
    local zone="--zone=$DNS_ZONE"
    local project="--project=phil-new"
    local tx="$gdns $project"

    rm -f transaction.yaml
    $tx start $zone
    $tx add "$target" --name="$hostname" $ttl --type="$record_type" $zone
    $tx execute $zone
    rm -f transaction.yaml
}

function gdns-mv {
    #
    # gdns-mv foo 127.0.0.1     # move whatever it points to now, to this
    #
    gdns-del "$1"
    gdns-add $*
}

function gdns-mv-cluster {
    #
    # gdns-mv-cluster ingress-phillies-aaron    # move our DNS entries to point to a new cluster CNAME
    #
    local ingress_cname="$1"     # "ingress-phillies-aaron"
    declare -a names=("api" "rocky" "hitting")

    if [ -z "$ingress_cname" ]; then
        echo
        echo "  gdns-mv-cluster ingress-phillies-aaron         # points everything to ingress-phillies-aaron"
        echo
        echo "  \"everything\" here means \"${names[@]}\""
        echo
        return
    fi

    for name in "${names[@]}"; do
        echo "Moving $name to $ingress_cname"
        gdns-mv $name $ingress_cname
    done
}

function gdns-ttl {
    local hostname="$1"
    local ttl="$2"

    if [ -z "$hostname" ]; then
        echo
        echo "  Usage:"
        echo "    gdns-ttl foo 60"
        echo
        echo "  TTL is in seconds"
        echo
        return
    fi

    echo
    echo "    Changing TTL for $hostname to: $ttl"

    local data=`gdns-ls ^$hostname | tr -s ' '`
    if [ -z "$data" ]; then
        echo "    Not found: $hostname"
        echo
        return
    fi

    local target="`echo $data | cut -d' ' -f4`"
    local record_type="`echo $data | cut -d' ' -f2`"
    local old_ttl="`echo $data | cut -d' ' -f3`"
    echo "    TTL is currently: $old_ttl"
    echo "    Will delete the DNS record, then add a new one"

    gdns-del $hostname
    echo
    gdns-add $hostname $target $ttl $record_type
}

function gdns-del {
    #
    # gdns-del veggietronic-tunnel
    #
    local hostname="$1"       # "foobar.$DOMAIN_FQ"

    if [ -z "$hostname" ]; then
        echo
        echo "  gdns-del foo"
        echo
        return
    fi

    if [[ "$hostname" != *$DOMAIN ]]; then
        hostname="$hostname.$DOMAIN_FQ"
        echo
        echo "    Deleting hostname: $hostname"
    fi

    local data=`gdns-ls ^$hostname | tr -s ' '`
    if [ -z "$data" ]; then
        echo "    Not found: $hostname"
        echo
        return
    fi
    echo

    local target="`echo $data | cut -d' ' -f4`"
    local record_type="`echo $data | cut -d' ' -f2`"
    local ttl="`echo $data | cut -d' ' -f3`"

    local gdns="gcloud dns record-sets transaction"
    local zone="--zone=$DNS_ZONE"
    local project="--project=phil-new"
    local tx="$gdns $project"

    rm -f transaction.yaml
    $tx start $zone
    $tx remove "$target"  --name="$hostname" --type="$record_type" --ttl=$ttl $zone
    $tx execute $zone
    rm -f transaction.yaml
}
function gdns-ls {
    hostname="$1"
    local zone="--zone=$DNS_ZONE"
    local cmd="gcloud dns record-sets list $zone"
    if [ -z "$hostname" ]
    then
        $cmd
    else
        $cmd | grep $hostname
    fi
}


#
# CHEF
#
export OPSCODE_USER=zo
alias cc='chef-client -l info'
alias ccd='chef-client -l debug'
# alias k='knife'
# alias kg='knife google'
# alias ke='knife ec2'
alias kinst='knife cookbook site install'
alias kservers='knife google server list --gce-project $PHIL_GCLOUD_PROJECT --gce-zone $PHIL_GCLOUD_ZONE'
alias ks='knife status'
alias ck='knife cookbook'
alias up='knife cookbook upload'
alias upp='up phillies'
alias upr='knife upload'
alias upe='knife environment from file'
alias upu='knife data bag from file users $1'
alias kshow='knife node show'
alias kedit='knife node edit'
alias urp='upr'
alias chef-all='pie && ROLES=all bundle exec cap prod chef && cd -'
alias chef-api='pie && ROLES=api bundle exec cap prod chef && cd -'
function ksearch {
    knife search node "roles:$1"
}
function kd {
    knife node delete -y $1
    knife client delete -y $1
}


#
# VAGRANT
#
#export VAGRANT_CWD=~/phillies/chef           # Lets you run vagrant from any directory
#export VAGRANT_DEFAULT_PROVIDER="vmware_fusion"
alias vst='vagrant status'

#
# KAFKA
#
KAFKA_HOME=$HOME/phillies/kafka/confluent-3.3.1
SQLLINE_HOME=$HOME/phillies/kafka/sqlline


# GIT'R DONE!
alias b='git co --track'  # b <branch_name>
alias bis='git bisect'
alias bs='git branch' # list all branches
alias bs-dates="git for-each-ref --sort=committerdate refs/heads/ --format='%(committerdate:short) %(refname:short)'"
alias gi='git'
alias god='git'
alias gd='git diff'
alias ga='git add'
alias gr='git restore'
alias st='git status'
alias co='git checkout'
alias gpl='git pull origin `git rev-parse --abbrev-ref HEAD`'
# alias merge-main='co phy-merge && git merge main && git push'
alias branch='co -b'
alias stash='git stash'
alias stahs='stash'
alias sta='stash'
alias master='co master'
alias main='co main'
alias dev='co dev'
# alias devv='co phy-merge'
alias gps='git push origin `git rev-parse --abbrev-ref HEAD`'
# alias got='git'
alias gut='git'
alias bfg='/usr/local/opt/openjdk/bin/java -jar /usr/local/Cellar/bfg/1.14.0/libexec/bfg-1.14.0.jar'

function gitclone {
    #
    # Usage: gitclone foo
    #
    local repo="$1"
    local org="PhilliesAnalytics"
    git clone "git@github.com:$org/$repo.git"
    cd $1
    git config pull.rebase false
    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
    git pull --all
    cd ..
}

function wip {
    COMMENT="$*"
    git status --untracked-files=no
    sleep 2
    git commit -a -m "WIP: $COMMENT"
    gps
}


function git-show-largest-files {
    git rev-list --objects --all \
    | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
    | awk '/^blob/ {print substr($0,6)}' \
    | sort --numeric-sort --key=2 --reverse \
    | head -20 \
    | cut --complement --characters=13-40 \
    | numfmt --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
}

function branchd {
    branch=$1
    if [ "$branch" = "" ]; then
        echo "No branch specified. Exiting."
        return
    fi
    # cd ~/phillies/uploader
    git branch -D $1
    git push origin --delete $1
    # cd -
}
function branchm {
    branch=$1
    if [ "$branch" = "" ]; then
        echo "No branch specified. Exiting."
        return
    fi
    # cd ~/phillies/uploader
    git checkout -b $1
    git push origin $1
    cd -
}

function tag-del {
    git tag --delete $1
    git push --delete origin $1
}

function tag-list {
    for tag in `git tag`
    do
        echo "`git rev-list -n 1 $tag`: $tag"
    done
}

function tag-update-local {
    git fetch origin --tags
}

function gc {
    git commit -m '$@'
}

export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUPSTREAM="auto"

. ~/.git-prompt.sh
. ~/.git-completion.sh
. ~/.colors_bash

COLOR_NORMAL="\[\e[00m\]"
COLOR_GREEN_A="\[\e[0;92m\]"
COLOR_GREEN_B="\[\e[0;32m\]"
COLOR_END="\[\e[0m\]"
export PS1="${COLOR_GREEN_A}\T ${COLOR_END}\$(__git_ps1) ${COLOR_GREEN_B}\W > ${COLOR_END}"
# export PS1="${COLOR_GREEN_A}\T ${COLOR_END}\$(__git_ps1 )\h ${COLOR_GREEN_B}\W > ${COLOR_END}"  # WITH HOSTNAME
# export PS1="${COLOR_GREEN_A}\T \$(__kube_ps1)${COLOR_END}\$(__git_ps1) ${COLOR_GREEN_B}\W > ${COLOR_END}"
# export PS1="${COLOR_GREEN_A}\T \$(__kube_ps1)${COLOR_END}$(__git_ps1 " (%s)") ${COLOR_GREEN_B}\W > ${COLOR_END}"
# export PS1='\[\e[0;92m\]\T\[\e[0m\]$(__git_ps1 " (%s)")\[\e[0m\] \[\e[0;32m\]\W > \[\e[0m\]'
# export PS1='\[\e[0;92m\]\T\[\e[0m\] \[\e[0;92m\]`hostname`\[\e[0m\]\[\e[0;92m\]$(__git_ps1 " (%s)")\[\e[0m\] \[\e[0;32m\]\W > \[\e[0m\]'


# CHROME
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"
alias chromium="/Applications/Chromium.app/Contents/MacOS/Chromium"


# MANDRILL
function get-mandrill {
    python $PHY/reports/bin/get_mandrill_html.py $1 > /tmp/message.html
    cat /tmp/message.html
}

# ELASTICSEARCH
function curles {
    curl -s "localhost:9200/$1" | python -m json.tool
}

# DROPBOX
export DROPBOX_HOME="/Users/zo/Dropbox"
alias edg='cd $DROPBOX_HOME/Phillies/edger'
alias phil='cd $DROPBOX_HOME/Phillies'

# NOTES
function notes {
    # shopt nullglob

    local dir=$DROPBOX_HOME/Phillies
    if [ $# -eq 0 ]; then
        ls -altr $dir/notes.* | sed -e "s/\/Users\/zo\/Dropbox\/Phillies\///"
        # find $dir -maxdepth 1 -name notes\* -print0 | xargs -0 stat -f "%a"
        return
    fi

    # if [ -f "$dir/notes.$1*.txt" ]; then
    if ls $dir/notes.$1*.txt > /dev/null 2>&1; then
        # echo "File exists"
        vi $dir/notes.$1*.txt
    else
        # echo "File DOES NOT exists"
        vi $dir/notes.$1.txt
    fi
}
function notesgrep {
    local arg="$1"
    grep -i "$arg" $DROPBOX_HOME/Phillies/note*.txt
}
alias notesg=notesgrep
alias note=notes
alias ntoes=notes


# PAPERTRAIL
alias pt='papertrail'
function l {
    group=$1

    if [ "$group" = "" ]; then
        echo "No group specified. Using ALL"
        group=""
    else
        group="-g $group"
    fi
    pt -f $group | nojello
}



#
# API
#
function api-local {
    curl ${@:2} -s -H "Authorization: Bearer $TOKEN" "http://localhost:5001/$1"
}
function api {
    curl ${@:2} -s -H "Authorization: Bearer $TOKEN" "https://$PHIL_API_SERVER/$1" | jq .
}
function apipost {
    curl ${@:2} -s -H "Authorization: Bearer $TOKEN" "https://$PHIL_API_SERVER/$1" -X POST
}
function apio {
    curl ${@:2} -s -H "Authorization: Bearer $TOKEN" "https://$PHIL_API_SERVER/$1"
}
function apiy {
    curly -i -o /dev/null $2 -H "Authorization: Bearer $TOKEN" "https://$PHIL_API_SERVER/$1"
}
function apiyz {
    curly ${@:2} -s -H "Accept-Encoding: gzip" -H "Authorization: Bearer $TOKEN" "https://$PHIL_API_SERVER/$1"
}

function pie-comp-dir {
    local dir="$1"
    if [ -z "$dir" ]; then
        dir=.
    fi

    local dir1=$PHY/$dir
    local dir2=$PIE/$dir

    local pyfiles1=`find $dir1 -name "*.py" | sort | awk -F"phy" '{print $2}' | cut -d'/' -f2-`
    local pyfiles2=`find $dir2 -name "*.py" | sort | awk -F"pie" '{print $2}' | cut -d'/' -f2-`

    local file1="/tmp/pyfiles1"
    local file2="/tmp/pyfiles2"

    echo "$pyfiles1" > $file1
    echo "$pyfiles2" > $file2

    comm -1 $file1 $file2

    # rm $file1 $file2
}

function pie-diff {
    local filename="$1"

    # get the relative path, no matter which repo were in
    local abs=`pwd`/$filename   # the absolute path to the file
    local rel=${abs#"$PIE/"}    # strip the PIE prefix
    rel=${rel#"$PHY/"}          # strip the PHY prefix

    # set absolute file paths
    phy_file="$PHY/$rel"
    pie_file="$PIE/$rel"

    # echo "< $phy_file"
    # echo "> $pie_file"
    # echo
    echo "Comparing:"
    echo $phy_file
    echo $pie_file
    echo
    echo
    diff $phy_file $pie_file
}

function lint-time-dir {
    local dir="$1"
    if [ -z "$dir" ]; then
        dir=.
    fi

    # name this run
    local run="$dir"-$RANDOM

    # get all the python files
    local python_files=`find $dir -name "*.py" | sort`

    # filter out some files
    local files=$python_files
    files=`echo "$files" | grep -v "\\\.coverage"`
    files=`echo "$files" | grep -v "\\\.env"`

    for file in $files; do
        lint-time-file "$file" "$run"
    done
}

function lint-time-file {
    local file="$1"
    local run="$2"

    local now=`date -u +"%F %T"`
    echo $now: $file
    local prefix="$now"
    local output=$(make lint DIR="$file" 2> /dev/null)
    local num_statements=`echo "$output" | grep "statements ana" | cut -d' ' -f1`
    local rating=`echo "$output" | grep "rated at" | cut -d' ' -f7 | cut -d'/' -f1`
    local timing=`echo "$output" | grep "lint took" | head -1 | cut -d' ' -f4`
    local sloc=`sloccount "$file" | grep python: | tr -s ' ' | cut -d' ' -f2`
    local hostname=`hostname`

    if [[ -z "$sloc" ]]; then
        sloc=0
    fi

    if [[ "$rating" == "10.00" ]]; then
        echo $prefix: $file OK, $timing seconds, $sloc LOC, $num_statements analyzed
    elif [[ "$sloc" == "0" ]]; then
        echo "$prefix: $file OK empty"
    else
        echo "$prefix: $file ERROR"
        # echo "$output"
    fi

    csvline=\"$now\",\"$hostname\",$run,$file,$timing,$sloc,$num_statements
    echo $csvline >> "$HOME/lint-times.csv"
}

function healths {
    for file in "$@"; do
        health $file
    done
}
function health {
    local filename="$1"
    filename=${filename#"phy"}
    filename=${filename#"/"}

    cd $PIE

    if [ -z "$filename" ]; then
        echo
        echo "$filename does not exist. Skipping."
        echo
        return
    fi

    make health DIR=$filename OPTIONS=-q
    cd -
}


# DIRS
alias src='cd $SRC_HOME'
alias re='cd $PIE/reports'
alias rep='re'
alias a='cd $PIE/biomech/amti'
alias u='cd $PIE/uploader'
alias bio='cd $PIE/biomech'
alias vid='cd $PIE/video'
alias pie='cd $PIE'
alias ts='cd ~/phillies/ts'
alias pid='cd $PIE/etc/docker/pie'
alias pig='cd $PIE/.github/workflows'
alias pik='cd $PIE/etc/kubernetes'
alias ku=pik
alias pso='cd $SRC_HOME/pitch-selection-optimization'
alias carm='cd $SRC_HOME/carmelo_update'
alias pie-path='export PYTHONPATH=$SRC_HOME'
alias c='cd $SRC_HOME/chef'
alias v='cd $SRC_HOME/chef/cookbooks/phillies/recipes'
alias e='cd $SRC_HOME/chef/environments'
alias r='cd $SRC_HOME/chef/roles'
alias dot='cd ~/.dotfiles'
alias dag='cd $PIE/cloud_composer/dags'
alias ib='cd $SRC_HOME/ibp-dashboards'


# ANDROID
alias logcat='adb logcat > /tmp/logcat.txt &'
alias logall='tail -f /tmp/logcat.txt'
alias adb-restart='adb kill-server; adb start-server'
# export GRADLE_OPTS="-Dorg.gradle.daemon=true" 


# LOADER
function loader {
    curl -s -H "loaderio-auth: $LOADERIO_KEY" https://api.loader.io/v2/servers | jq .
}


# VARNISH
alias vl='varnishlog -m rxURL:/rss/blog -c'
function vpurge {
    curl -s -v -o /dev/null -X $VARNISH_VERB https://$VARNISH_USER:$VARNISH_PASS@$VSCO_PROD$1 2>&1 >/dev/null | grep HTTP
}


# some default locations
export NGINX_HOME=/usr/local/Cellar/nginx/current
export APACHE_HOME=/usr/local/apache2
export NPM_HOME=/usr/local/share/npm/
export ANDROID_HOME=~/adt-bundle-mac/sdk
export HEROKU_HOME=/usr/local/heroku
export NPM_RELATIVE="./node_modules/.bin"
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export GSUTIL_HOME=~/bin/gsutil


# BREW
function brew-update() {
    pushd .
    dot
    brew update
    brew bundle
    popd
}


# IDEMPOTENT PATHS
add_to_CLASSPATH () {
  for d; do
    # d=$(cd -- "$d" && { pwd -P || pwd; }) 2>/dev/null  # canonicalize symbolic links
    # if [ -z "$d" ]; then continue; fi  # skip nonexistent directory
    case ":$CLASSPATH:" in
      *":$d:"*) :;;
      *) CLASSPATH=$CLASSPATH:$d;;
    esac
  done
}

add_to_PATH () {
  for d; do
    # d=$(cd -- "$d" && { pwd -P || pwd; }) 2>/dev/null  # canonicalize symbolic links
    # if [ -z "$d" ]; then continue; fi  # skip nonexistent directory
    case ":$PATH:" in
      *":$d:"*) :;;
      *) PATH=$PATH:$d;;
    esac
  done
}

# JAVA
function finder {
    find . -name '*.jar' -exec grep -Hls $1 {} \;
}
export MYSQL_CONNECTOR_HOME=$HOME/phillies/kafka/mysql-connector-java-5.1.44
add_to_CLASSPATH .
add_to_CLASSPATH $HOME/phillies/data/activemq/target/dependency/*
add_to_CLASSPATH $HOME/phillies/data/activemq/target/classes
add_to_CLASSPATH $HOME/jars-kafka-serde-tools/*
add_to_CLASSPATH $HOME/jars-schema-registry/*
add_to_CLASSPATH $MYSQL_CONNECTOR_HOME/mysql-connector-java-5.1.44-bin.jar
add_to_CLASSPATH $HOME/phillies/kafka/sqlline/target/sqlline-1.4.0-SNAPSHOT-jar-with-dependencies.jar

# export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
# export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
add_to_PATH /usr/local/opt/coreutils/libexec/gnubin
add_to_PATH $PYTHON3_HOME/bin/
add_to_PATH $PYTHON3_HOME/libexec/bin/
add_to_PATH /usr/local/bin
add_to_PATH /usr/local/sbin
add_to_PATH $NPM_RELATIVE
add_to_PATH $GOPATH/bin
# add_to_PATH /usr/local/opt/openssl/bin
add_to_PATH /usr/local/opt/mysql-client/bin
add_to_PATH /opt/homebrew/bin
add_to_PATH $GSTREAMER_HOME/bin/
add_to_PATH ~/bin
add_to_PATH .
# add_to_PATH $NPM_HOME/bin
# add_to_PATH $KAFKA_HOME/bin
# add_to_PATH $SQLLINE_HOME/bin
# add_to_PATH /Library/TeX/texbin

# LUNCHY
# LUNCHY_DIR=$(dirname `gem which lunchy`)/../extras
  # if [ -f $LUNCHY_DIR/lunchy-completion.bash ]; then
    # . $LUNCHY_DIR/lunchy-completion.bash
# fi




# PHOTO
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

    JALBUM_HOME=$HOME/Photos
    JALBUM_SETTINGS=$JALBUM_HOME/jalbum-settings.jap

    #JALBUM_JAR="/Applications/jAlbum.app/Contents/Resources/Java/JAlbum.jar"
    JALBUM_JAR="$HOME/Dropbox/Code/jAlbum/JAlbum.jar"
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
            echo
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
    rs-parsename    $fullname
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
    rs-parsename    $fullname

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

      dns-delete $1            vsco.co
      dns-delete $1-private    vsco.co
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


[ -f $HOME/.z.sh ] && source $HOME/.z.sh
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
# export PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
# export PATH=/usr/local/bin:$PATH
# export PATH="$HOME/.poetry/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
export GOOGLE_CLOUD_DIR="/Users/zo/src/google-cloud-sdk"
if [ -f $GOOGLE_CLOUD_DIR/path.bash.inc ]; then . $GOOGLE_CLOUD_DIR/path.bash.inc; fi

# The next line enables shell command completion for gcloud.
if [ -f $GOOGLE_CLOUD_DIR/completion.bash.inc ]; then . $GOOGLE_CLOUD_DIR/completion.bash.inc; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# uv
export PATH="/Users/zo/.local/bin:$PATH"
