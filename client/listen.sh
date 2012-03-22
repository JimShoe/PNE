#!/bin/bash

USER="laptop"
PASS="banana"

LOCK="/tmp/PNE.lock"
if [ -f $LOCK ]; then
  exit
fi
touch $LOCK


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

get_icon () {
  url=$1
  icon="/tmp/"${url##*/}
  if [ ! -f $icon ]; then
    wget -q $url -O $icon
  fi
}

while : ; do
 wget -q -O - --timeout=5 -i - <<< "https://dev.throwthemind.com/m/listen.php?user=$USER&pass=$PASS" | while read m
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
  done                                                                # done with wget
sleep 5;                                                              # retry wget
done
