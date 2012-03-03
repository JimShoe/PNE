<?php
$ini = parse_ini_file("config.ini", true);

// check username and pass with ini file
function register($user, $pass){
  global $ini;
  if(array_key_exists($user,$ini) && ($pass == $ini[$user]['pass'])){
    return TRUE;
  }
  return FALSE;
}

// check if user is active, meaning user has checked the queue in the last 2 sec.
function user_active($user){
  global $ini;
  $MSGKEY = $ini[$user]['queue_id'];
  if (msg_queue_exists($MSGKEY)){
    $queue = msg_get_queue($MSGKEY); 
    $queue_status = msg_stat_queue($queue);
    if((time() - $queue_status['msg_ctime']) <= 2)return TRUE;
  }
  return FALSE;
}

?>
