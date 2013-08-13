#!/bin/bash

USER="deathstar"
PASS="banana"
SERVER="https://frcv.net/PNE/server"
msg_type="command"
msg="command<*>$SERVER/icons/hash_icon.png<*>$1<*>$2"

wget -q -O - -i - <<< "$SERVER/send.php?user=$USER&pass=$PASS&msg_type=$msg_type&msg=$msg" > /dev/null
