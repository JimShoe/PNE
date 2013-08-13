#!/bin/bash

USER="laptop"
PASS="banana"
SERVER="https://frcv.net/PNE/server"
msg=$1

wget -q -O - -i - <<< "$SERVER/send.php?user=$USER&pass=$PASS&msg_type=weechat&msg=$msg" > /dev/null
