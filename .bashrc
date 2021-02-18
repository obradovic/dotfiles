#
# COMMON
#
shopt -s extglob
set -o vi
umask 0022

# ENVS
export SRC_HOME="$HOME/phillies"
export PHILLIES_PATH=$SRC_HOME/phillies
export PHY=$PHILLIES_PATH/phy
export DYLD_LIBRARY_PATH=/usr/local/opt/mysql-client/lib/
export LESS="-XFR"

# BASH
export CLICOLOR=1
export HISTFILE=~/.history_bash
# export HISTSIZE=5000
# export HISTFILESIZE=5000
# export HISTIGNORE="&:ls:[bf]g:exit:[ \t]*"
export EDITOR=vi
export BASH_SILENCE_DEPRECATION_WARNING=1  # https://www.addictivetips.com/mac-os/hide-default-interactive-shell-is-now-zsh-in-terminal-on-macos/
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

function dv {
    file="$1"
    diff ~/video.prod/$file ~/video.dev/$file
}

#
# GENERIC BASH ALIASES AND FUNCTIONS
#
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
alias please='sudo'
alias sudo='sudo '  # from http://www.shellperson.net/using-sudo-with-an-alias/
alias yolo="sudo $(history | tail -2 | head -1 | tr -s ' ' | cut -d' ' -f3-)"
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
alias tl='tail -f'
alias beep='for i in {1..3} ; do tput bel; sleep 0.5; done'
alias js='python3 -m json.tool'
alias less='less -X -F'
alias grepl='grep --line-buffered'
alias noempty='egrep --line-buffered -v "^[[:space:]]*$"'
alias nojello='grep --line-buffered -v jello'
alias ports='netstat -tulan'
alias .ale='make'
alias utc='date -u'
alias ut='utc'
alias tp='make phy-typecheck && make phy-lint'

function run() {
    # runs something n times
    number=$1
    shift
    for n in $(seq $number); do
      $@
    done
}
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
    curl -s http://api.ipstack.com/$1?access_key=$IPSTACK_TOKEN | jq .continent_name,.country_name,.region_name,.city
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
# GITHUB ACTIONS
#
alias g='cd $PHY/../.github'
alias w='g && cd workflows'
alias sc='g && cd scripts'


#
# DOCKER
#
alias d='docker'
alias dc='d container'
alias di='d image'
alias dps='d ps -a'
alias doc='cd $PHILLIES_PATH/.docker/dash'
alias ama='cd $PHY/dash/ama'
alias dc='docker-compose -f $PHILLIES_PATH/.docker/phy-compose/docker-compose.yml'
alias drun='docker container run'
alias pc-up="(cd $PHILLIES_PATH && make pc-up)"
alias pc-down="(cd $PHILLIES_PATH && make pc-down)"
alias pc-enter="(cd $PHILLIES_PATH && make pc-enter)"

function ubuntu-R {
    run-in-container flex "/usr/bin/R --no-save -q"
}
alias dr=ubuntu-R

function ubuntu-bash {
    run-in-container flex "/bin/bash"
}
alias dbash=ubuntu-bash

function run-in-container {
    local image="$1"
    local cmd="$2"
    local image_full="gcr.io/phil-new/$image:latest"
    local container_id=`docker ps | grep $image_full | cut -d' ' -f1`

    # start it, if its not running
    if [ -z "$container_id" ]; then
        # echo "Starting container $image_full"
        started_id=`docker container run -p 8000:80 -d --hostname $image --detach $image_full`
        container_id=$started_id
    fi
    container_id=`echo $container_id | cut -c-12`   # make it a short id

    echo
    echo "  Entering $image container $container_id"
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
#
#
alias aw='awair --mac 70:88:6b:14:10:a1'


#
# KUBE
#
alias k=kubectl
alias kg='k get'
alias kall='k get all -A --show-labels'
complete -F __start_kubectl k  # from https://kubernetes.io/docs/reference/kubectl/cheatsheet/

function kget {
    kubectl get $*
}
function kj {
    kget $* -o json | jq .
}
function ky {
    kget $* -o yaml
}
alias deps='kget deployments'
alias dep='kj deployment'
alias pods='kget pods'
alias pod='kj pod'
alias svcs='kget services'
alias svc='kj service'
alias clusters='gcloud container clusters list'
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

    cd $PHILLIES_PATH/.docker/dash
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


#
# HELM
#
alias hls='helm ls --all -A'
function h {
    if [ -z "$*" ]; then
        cd $PHILLIES_PATH/.helm
        return
    fi
    helm $*
}



#
# GCLOUD
#
export CLOUDSDK_PYTHON=/usr/local/bin/python3
export DNS_ZONE='philsio-zone'
alias dns='gcloud dns'
alias dns-transaction='dns record-sets transaction'
alias dns-list-all='dns record-sets list --zone $DNS_ZONE'
function dns-list {
    dns-list-all --name $1.phils.io.
}
function dns-create {
    local name=$1.phils.io.
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
    local name=$1.phils.io.

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


# VEGGIETRONIC
alias veg-attachment='curl -v http://veggietronic-zo.phils.io/static/mnt/sdcard/DCIM/slomo_1582467987_2.mov > /dev/null'
alias veg-attachment-no='curl -v http://veggietronic-zo.phils.io/static/asattachment/mnt/sdcard/DCIM/slomo_1582467987_2.mov > /dev/null'

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
export LIBRARY_PATH=$GSTREAMER_HOME/lib
export PATH=$PATH:$GSTREAMER_HOME/bin
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
alias my='mypy --config-file $PHY/setup.cfg'
function mypylint {
    filename="$1"
    pycodestyle --count --max-line-length=160 "$filename"
    mypy --config-file $PHY/setup.cfg "$filename"
    pylint --rcfile $PHY/.pylintrc "$filename"
}
function i {
    touch `dirname $1`/__init__.py
}

if [ -f $HOME/.bashrc_private ]; then
    source $HOME/.bashrc_private
fi

if [ -f $PHY/bin/gcp-shared.sh ]; then
    source $PHY/bin/gcp-shared.sh
fi



#
# RASPBERRY PI
#
alias rube-net='ssh zo@`arp-scan -l | grep -i "raspberry\|legra" | head -1 | cut -f1`'
alias rube-local='screen /dev/cu.usbserial 115200'
alias rube-eth='ssh pi@192.168.2.2'


# OSX NOTIFICATIONS
alias notifications-enable='launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist'
alias notifications-disable='launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist; killall NotificationCenter'


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
export PYENV_VERSION=2.7.13
export PYTHONPATH=$SRC_HOME/phillies
export PYTHONDONTWRITEBYTECODE=true
export MYPYPATH=$PYTHONPATH

export WHEELHOUSE="${HOME}/.cache/pip/wheelhouse"
export PIP_FIND_LINKS="file://${WHEELHOUSE}"
export PIP_WHEEL_DIR="${WHEELHOUSE}"
mkdir -p $WHEELHOUSE

alias e='source .env/bin/activate'
alias rmp='find . -name \*.pyc | xargs rm'
# alias py='cat .ipython.py && ipython3 --no-banner --pprint -i --'
alias py='ipython3 --no-banner --pprint --no-simple-prompt -i --'
alias ac='. .env/bin/activate'
alias ac3='. .py3env/bin/activate'
alias pip='python3 -m pip'
alias pi='pip install'
alias pir='pi -r requirements.txt'
alias pirv='virtualenv .env && ac && pir'
alias env_create='pyenv virtualenv $PYENV_VERSION .env'

function pll {
    local package="$1"
    local cmd="pip list"
    if [ -z "$hostname" ]
    then
        $cmd | grep "$package"
    else
        $cmd
    fi
}
alias pl=pll

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


#
# RUBY
#
alias be='bundle exec'
# alias bcap='bundle exec cap'
# alias dep='bundle exec cap prod deploy'
# source ~/.rvm/scripts/rvm



#
# GO
#
export GOPATH=~/go


#
# VMWARE
#
alias vmrun="/Applications/VMware\ Fusion.app/Contents/Public/vmrun"


# EDGERTRONIC
function edg-status-watch {
    # from https://wiki.edgertronic.com/index.php/SDK_-_Developer_tricks
    s="" ; while sleep 0.5 ; do t=`curl http://e/get_status_string 2>/dev/null` ; if [ "$s" != "$t" ] ; then s=$t ; echo $s ; fi ; done
}

# GCLOUD
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
function datalab {
  gcloud compute ssh --quiet \
  --project $PHIL_GCLOUD_PROJECT \
  --zone $PHIL_GCLOUD_ZONE \
  --ssh-flag="-N" \
  --ssh-flag="-L" \
  --ssh-flag="localhost:8081:localhost:8080" \
  "zo@prod-datalab-1"
}
function g-create-template {
    g-create2 $1 $1-$2 template 30 n1-standard-1
}
function g-create-edger-4 {
    g-create2 $1 $1-$2 edger 100 c2-standard-4
}
function g-create-edger-8 {
    g-create2 $1 $1-$2 edger 100 c2-standard-8
}
function g-create-edger-16 {
    g-create2 $1 $1-$2 edger 100 c2-standard-16
}
function g-create-edger-30 {
    g-create2 $1 $1-$2 edger 100 c2-standard-30
}
function g-create-edger-60 {
    g-create2 $1 $1-$2 edger 100 c2-standard-60
}
function g-create-edger-n2 {
    g-create2 $1 $1-$2 edger 100 n2-standard-80
}
function g-create-edger-gpu {
    g-create2 $1 $1-$2 edger-gpu 100 n1-highmem-16  # same as megacron
}
function g-create-ghealey {
    g-create2 $1 $1-$2 base 100 n1-standard-8
}
function g-create-tunnel {
    g-create $1 $1-$2 tunnel 50 n1-standard-1
}
function g-create-db {
    g-create $1 $1-$2 db 500 n1-standard-2
}
function g-create-draft {
    g-create $1 $1-$2 draft 50 n1-standard-1
}
function g-create-api {
    g-create $1 $1-$2 api 200 n1-standard-4
}
function g-create-box {
    g-create $1 $1-$2 box 200 n1-standard-4
}
function g-create-infield {
    g-create $1 $1-$2 infield 100 n1-standard-2
}
function g-create-lb {
    g-create2 $1 $1-$2 lb 100 n1-standard-2
    gcloud compute instances add-tags $1-$2 --tags http-server,https-server
}
function g-create-lbvideo {
    g-create2 $1 $1-$2 lbvideo 100 n1-standard-2
    gcloud compute instances add-tags $1-$2 --tags http-server,https-server,allow-rtsp,allow-vnc-lb
}
function g-create-shiny {
    g-create $1 $1-$2 shiny 150 n1-standard-2
}
function g-create-datalab {
    g-create $1 $1-$2 datalab 100 n1-standard-2
}
function g-create-jupyter {
    g-create $1 $1-$2 jupyter 100 n1-standard-16
}
function g-create-megacron {
    g-create2 $1 $1-$2 megacron 1000 n1-highmem-16
}
function g-create-generic {
    g-create2 $1 $1-$2 generic 100 n1-standard-16
}
function g-create-ftp {
    g-create2 $1 $1-$2 ftp 200 n1-standard-1
}
function g-create-elephant {
    g-create2 $1 $1-$2 elephant 200GB c2-standard-60
}
function g-create {
    echo ARGS are $*
    knife google server create $2 \
    --bootstrap-version 13.12.14 \
    --gce-machine-type $5 \
    --gce-boot-disk-size $4 \
    --gce-boot-disk-ssd true \
    --gce-image ubuntu-1604-lts \
    --gce-project $PHIL_GCLOUD_PROJECT \
    --gce-zone $PHIL_GCLOUD_ZONE_1 \
    --ssh-user $CHEF_USERNAME \
    --identity-file ~/.ssh/id_rsa \
    --environment $1 \
    --request-timeout 6000 \
    --auth-timeout 300 \
    --run-list "role[$3]"
}

function g-create2 {
    env=$1
    name=$2
    chef_role=$3
    disk_size=$4
    machine_type=$5

    boot_disk_type=pd-ssd
    min_cpu_platform="skylake"

    # when you add an accelerator, you can only have 16 cpus max
    # T4 only in us-east1-c, see: gcloud compute accelerator-types list | grep nvidia-tesla-t4
    gpu=""
    zone="$PHIL_GCLOUD_ZONE_1"
    if [ "$chef_role" == "elephant" ]; then
        # gpu="--accelerator type=nvidia-tesla-t4,count=1 "
        zone="us-east1-b"
    fi

    if [[ "$name" == *"t4"* ]]; then
        gpu="--accelerator type=nvidia-tesla-t4,count=1 "
        zone="us-east1-c"
    fi
    if [[ "$name" == *"p100"* ]]; then
        gpu="--accelerator type=nvidia-tesla-p100,count=1 "
        zone="us-east1-c"
    fi
    if [[ "$name" == *"k80"* ]]; then
        gpu="--accelerator type=nvidia-tesla-k80,count=1 "
        zone="us-east1-c"
    fi
    if [[ "$name" == *"p4"* ]]; then
        gpu="--accelerator type=nvidia-tesla-p4,count=1 "
        zone="us-east4-a"
    fi
    if [[ "$name" == *"v100"* ]]; then
        gpu="--accelerator type=nvidia-tesla-v100,count=1 "
        zone="us-central1-c"
    fi

    # Cascade Lake CPUs are only available in this DC for now
    # CORRECT INFO: gcloud compute machine-types list
    # BAD INFO: https://cloud.google.com/compute/docs/regions-zones/#available
    if [[ "$machine_type" == "c2-standard-"* ]]; then
        # zone="us-central1-c"
        min_cpu_platform="cascadelake"
    fi

    if [[ "$machine_type" == "n2-standard-"* ]]; then
        zone="us-central1-f"
        min_cpu_platform="cascadelake"
    fi

    image=`get-latest-image`
    # image="ubuntu-1604-lts"
    # image="ubuntu-1604-xenial-v20190628"
    # image="ubuntu-1604-xenial-v20191204"
    # image="ubuntu-1804-bionic-v20191211"
    # image="ubuntu-os-cloud"

    echo "IMAGE: $image"
    echo "ZONE: $zone"
    echo "NAME: $name"
    echo "BOOT DISK: $boot_disk_type"
    echo "MACHINE TYPE: $machine_type"
    echo "MIN CPU PLATFORM: $min_cpu_platform"
    echo "PHIL_GCLOUD_PROJECT: $PHIL_GCLOUD_PROJECT"
    echo "GPU: $gpu"

    command="$compute instances create $name \
        --boot-disk-size $disk_size \
        --boot-disk-type $boot_disk_type \
        --labels env=$env,name=$name \
        --machine-type $machine_type \
        --maintenance-policy TERMINATE --restart-on-failure \
        --restart-on-failure \
        --min-cpu-platform $min_cpu_platform \
        --image $image \
        --project $PHIL_GCLOUD_PROJECT \
        --zone $zone \
        $gpu \
        --format json"

    echo "COMMAND: $command"
    response=`$command`
    echo $response

    status=`echo $response | jq -r .[0].status`
    if [ "$status" != "RUNNING" ]; then
        echo $response | jq
        echo "ERROR: $name is NOT RUNNING"
        return
    fi

    ip=`echo $response | jq -r .[0].networkInterfaces[0].accessConfigs[0].natIP`

    ssh-keygen -R $ip
    whitelist $name $ip
    g-bootstrap $env $chef_role $name $ip $zone
}

function g-bootstrap {
    env=$1
    chef_role=$2
    name=$3
    ip=$4
    zone=$5  # unused rn

    knife bootstrap $ip \
        --bootstrap-version 13.12.14 \
        -E $env \
        -N $name \
        -i ~/.ssh/id_rsa \
        -x zo \
        -V \
        -r "role[$chef_role]" \
        --sudo
}

function g-delete {
    name="$1"
    zone="$PHIL_GCLOUD_ZONE"
    if [[ "$name" =~ "elephant" ]]; then
        zone="us-east1-c"
    fi

    knife google server delete --gce-project $PHIL_GCLOUD_PROJECT --gce-zone $zone -P $name
}

function g-stop {
    name=$1
    $compute instances stop $name --zone $PHIL_GCLOUD_ZONE
}
function g-start {
    name=$1
    $compute instances start $name --zone $PHIL_GCLOUD_ZONE
}


#
# SSH
#
alias mega='p megacron-1'
alias meg='mega'
alias lb="p lb-2"
alias lbv='ssh 35.237.94.24'
function g-ssh {
    gcloud compute ssh --project $PHIL_GCLOUD_PROJECT --zone $PHIL_GCLOUD_ZONE $1
}
function g-list {
    knife google server list --gce-project $PHIL_GCLOUD_PROJECT --gce-zone $PHIL_GCLOUD_ZONE_1
}
function g-list2 {
    knife google server list --gce-project $PHIL_GCLOUD_PROJECT --gce-zone $PHIL_GCLOUD_ZONE_2
}
function s {
    . ~/.bashrc
    local ip=`knife google server list  | grep -v terminated | grep $1 | tr -s ' ' | cut -d ' ' -f5`
    ssh $ip
}
function p {
    . ~/.bashrc
    local ip=`knife google server list  | grep -v terminated | grep prod | grep $1 | tr -s ' ' | cut -d ' ' -f5`
    ssh $ip
}
alias tun='ssh 34.73.92.181'
function cpbig {
    file="$1"
    ip="34.74.182.158"
    scp zo@$ip:/tmp/$file $file
}


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
function ssh-mac {
    local mac="$1"
    local ip=`arps | grep "$mac" | head -1 | cut -f1`
    ssh $ip
}
alias arps='arp-scan -l --plain --ignoredups | sort -b -k3,3 -k2,2'
alias arps1='arps | sort -k1,1n'
alias arps2='arps | sort -k2,2  -k1,1n'
alias arps3='arps | sort -k3,3f -k1,1n'

function macs {
    local file=/usr/local/share/arp-scan/mac-override.txt
    sudo vi $file
    sudo cp -f $file $file.bak
}


#
# DATABASE
#
function phil-db-local {
    mycli --port $PHIL_DOCKER_DB_PORT -h 127.0.0.1 -u$PHIL_DOCKER_DB_USER -p$PHIL_DOCKER_DB_PW phil_data
}
function phil-db {
    # echo Password copied
    # echo $PHIL_GCLOUD_DB_PW | pbcopy
    # gcloud beta sql connect $PHIL_GCLOUD_DB_INSTANCE -u $PHIL_GCLOUD_DB_USER
    # mysql -h $PHIL_GCLOUD_DB_IP $PHIL_GCLOUD_DB_NAME -u $PHIL_GCLOUD_DB_USER -p$PHIL_GCLOUD_DB_PW "$@"
    mycli -h $PHIL_GCLOUD_DB_IP $PHIL_GCLOUD_DB_NAME -u $PHIL_GCLOUD_DB_USER -p$PHIL_GCLOUD_DB_PW "$@"
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
function phil-db-root {
    mycli -h $PHIL_GCLOUD_DB_IP $PHIL_GCLOUD_DB_NAME -u root -p$PHIL_GCLOUD_DB_PW "$@"
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

# Updates PATH for the Google Cloud SDK.
if [ -f $HOME/src/google-cloud-sdk/path.bash.inc ]; then
  source $HOME/src/google-cloud-sdk/path.bash.inc
fi

# Enables shell command completion for gcloud.
if [ -f $HOME/src/google-cloud-sdk/completion.bash.inc ]; then
  source $HOME/src/google-cloud-sdk/completion.bash.inc
fi



#
# CHEF
#
export OPSCODE_USER=zo
alias cc='chef-client -l info'
alias ccd='chef-client -l debug'
# alias k='knife'
# alias kg='knife google'
alias ke='knife ec2'
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
alias chef-all='phy && ROLES=all bundle exec cap prod chef && cd -'
alias chef-api='phy && ROLES=api bundle exec cap prod chef && cd -'
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
alias b='git co'  # b <branch_name>
alias bs='git branch' # list all branches
alias gi='git'
alias god='git'
alias gd='git diff'
alias gad='git add'
alias st='git status'
alias co='git checkout'
alias gpl='git pull origin `git rev-parse --abbrev-ref HEAD`'
alias merge='git merge'
alias branch='co -b'
alias stash='git stash'
alias stahs='stash'
alias sta='stash'
alias prod='co prod'
alias master='prod'
alias dev='co dev'
alias gps='git push origin `git rev-parse --abbrev-ref HEAD`'
alias got='git'

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
    cd ~/phillies/uploader
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

COLOR_NORMAL="\[\033[00m\]"
COLOR_GREEN_A="\[\e[0;92m\]"
COLOR_GREEN_B="\[\e[0;32m\]"
COLOR_END="\[\e[0m\]"
export PS1="${COLOR_GREEN_A}\T ${COLOR_END}\$(__git_ps1) ${COLOR_GREEN_B}\W > ${COLOR_END}"
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
alias edg='cd ~/Dropbox/Phillies/edger'


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
    curl ${@:2} -s -H "Authorization: Bearer $TOKEN" "http://private:81/$1" | jq .
}
function api {
    curl ${@:2} -s -H "Authorization: Bearer $TOKEN" "https://$PHIL_API_SERVER/$1" | jq .
}
function apipost {
    curl ${@:2} -v -H "Authorization: Bearer $TOKEN" "https://$PHIL_API_SERVER/$1" -X POST
}
function apih {
    curl ${@:2} -s -H "Authorization: Bearer $TOKEN" "http://$PHIL_API_SERVER/$1" | jq .
}
function apio {
    curl ${@:2} -s -H "Authorization: Bearer $TOKEN" "https://$PHIL_API_SERVER/$1"
}
function apioh {
    curl ${@:2} -s -H "Authorization: Bearer $TOKEN" "http://$PHIL_API_SERVER/$1"
}
function apiy {
    curly -i -o /dev/null $2 -H "Authorization: Bearer $TOKEN" "https://$PHIL_API_SERVER/$1"
}
function apiyz {
    curly ${@:2} -s -H "Accept-Encoding: gzip" -H "Authorization: Bearer $TOKEN" "https://$PHIL_API_SERVER/$1"
}
function api-local {
    curl ${@:2} -s -H "Authorization: Bearer $TOKEN" "http:/localhost:5000/$1" | jq .
}
function api-localo {
    curl ${@:2} -s -H "Authorization: Bearer $TOKEN" "http://localhost:5000/$1" 
}
function api-localy {
    curly ${@:2} -s -i -o /dev/null $2 -H "Authorization: Bearer $TOKEN" "http://localhost:5000/$1"
}
function api-localyz {
    curly ${@:2} -s -H "Accept-Encoding: gzip" -H "Authorization: Bearer $TOKEN" "http://localhost:5000/$1"
}
function infield {
    curl ${@:2} -s -H "Authorization: Bearer $TOKEN" "https://infield.phils.io/$1" | jq .
}


# DIRS
alias src='cd  $SRC_HOME'
alias re='cd  $PHY/reports'
alias rep='re'
alias a='cd  $PHY/api'
alias u='cd  $PHY/uploader'
alias phy='cd  $PHY'
alias vid='phy && cd video'
alias c='cd  $SRC_HOME/chef'
alias v='cd  $SRC_HOME/chef/cookbooks/phillies/recipes'
alias e='cd  $SRC_HOME/chef/environments'
alias r='cd  $SRC_HOME/chef/roles'
alias dot='cd ~/.dotfiles'


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
    cd ~/.dotfiles
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

#export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
add_to_PATH /usr/local/opt/coreutils/libexec/gnubin
add_to_PATH /usr/local/opt/openssl/bin
add_to_PATH /usr/local/bin
add_to_PATH /usr/local/sbin
# add_to_PATH $NPM_HOME/bin
# add_to_PATH ~/bin
add_to_PATH .
add_to_PATH $NPM_RELATIVE
add_to_PATH $GOPATH/bin
add_to_PATH /usr/local/opt/openssl/bin
add_to_PATH /usr/local/opt/coreutils/libexec/gnubin
# add_to_PATH $KAFKA_HOME/bin
add_to_PATH $SQLLINE_HOME/bin
# add_to_PATH /Library/TeX/texbin
add_to_PATH /usr/local/opt/mysql-client/bin
add_to_PATH /opt/homebrew/bin
add_to_PATH ~/bin

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
export PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH=/usr/local/bin:$PATH
export PATH="$HOME/.poetry/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/zo/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/zo/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/zo/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/zo/Downloads/google-cloud-sdk/completion.bash.inc'; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
