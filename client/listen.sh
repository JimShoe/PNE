#!/bin/bash

USER="laptop"
PASS="banana"
SERVER="https://frcv.net/PNE/server"

LOCK="/tmp/PNE.LOCK";
exec 8>$LOCK;

if flock -n -e 8; then :
else
  exit 1;
fi

weechat_notify () {
  subject=$(echo $1 | sed 's/\&/and/g')
  body=$(echo $2 | sed 's/\&/and/g')
  focus=$(xwininfo -tree -id $(xdpyinfo | awk '/focus/ {gsub(",", "", $3); print $3}') | grep Parent | awk -F\" '{print $2}')
  if [[ $focus == weechat* ]]; then continue; fi
  /usr/bin/notify-send --icon=$icon "$subject" "$body"
}

command_notify () {
  subject=$(echo $1 | sed 's/\&/and/g')
  body=$(echo $2 | sed 's/\&/and/g')
  /usr/bin/notify-send --icon=$icon "$subject" "$body"
}

# if icon is not in /tmp, wget it
get_icon () {
  url=$1
  icon="/tmp/"${url##*/}
  if [ ! -f $icon ]; then
    wget -q $url -O $icon
  fi
}

# check if screensaver is on
screensaver_status () {
  xscreensaver-command -time | grep -q locked
}

while : ; do
  sleep 5
  screensaver_status && continue                          # if screensaver is on continue
    
 (wget -q -O - --timeout=5 -i - <<< "$SERVER/listen.php?user=$USER&pass=$PASS" | while read m
  do
    if [ ! -n "$m" ]; then continue; fi
    echo $m
    IFS=`echo -en "\n\b"`
    arr=()
    for i in `echo $m | sed 's/<\*>/\n/g'`; do
      arr=("${arr[@]}" "$i")
    done
    # check the message type and call notification functions
    msg_type=${arr[0]}
    if [ $msg_type == "weechat" ]; then
      get_icon ${arr[1]}
      weechat_notify ${arr[2]} ${arr[3]}
    fi
    if [ $msg_type == "command" ]; then
      get_icon ${arr[1]}
      command_notify ${arr[2]} ${arr[3]}
    fi
  done)&

  looppid=$!                                                   # get wget pid
  while [ -d /proc/$looppid ]; do                              # check if wget command is running
    screensaver_status && pkill -P $looppid && continue        # if screensave is on kill the wget and continue
    sleep 5                                                    # sleep is screensaver is off
  done   
done
