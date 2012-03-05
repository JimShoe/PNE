#!/bin/bash

USER="deathstar"
PASS="banana"
msg_type="command"
msg="command<*>Command Finished<*>$1"

wget -q -O - -i - <<< "https://dev.throwthemind.com/m/send.php?user=$USER&pass=$PASS&msg_type=$msg_type&msg=$msg" > /dev/null
