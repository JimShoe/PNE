#!/bin/bash

USER="laptop"
PASS="banana"

LOCK="/tmp/PNE.lock"
if [ -f $LOCK ]; then
  exit
fi
touch $LOCK


weechat_notify () {
  url=$1
  subject=$(echo $2 | sed 's/\&/and/g')
  body=$(echo $3 | sed 's/\&/and/g')
  url_fname="/tmp/"${url##*/}
  if [ ! -f $url_fname ]; then
    wget -q $url -O $url_fname
  fi
  focus=$(xwininfo -tree -id $(xdpyinfo | awk '/focus/ {gsub(",", "", $3); print $3}') | grep Parent | awk -F\" '{print $2}')
  if [[ $focus == weechat* ]]; then continue; fi
  /usr/bin/notify-send --icon=$url_fname "$subject" "$body"
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
    msg_type=${arr[0]}
    if [ $msg_type == "weechat" ]; then
      weechat_notify ${arr[1]} ${arr[2]} ${arr[3]}
    fi
    if [ $msg_type == "command" ]; then
      /usr/bin/notify-send ${arr[1]} ${arr[2]}
    fi
  done                                                                # done with wget
sleep 5;                                                              # retry wget
done
