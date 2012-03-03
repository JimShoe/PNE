#!/bin/bash

USER="laptop"
PASS="banana"
msg=$1

wget -q -O - -i - <<< "https://dev.throwthemind.com/m/send.php?user=$USER&pass=$PASS&msg_type=weechat&msg=$msg" > /dev/null
