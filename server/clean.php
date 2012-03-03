<?php
include("functions.php");

ob_implicit_flush(true);
foreach (array_keys($ini) as $user){ 
  $key = $ini[$user]['queue_id'];
  $msg_id = msg_get_queue ($key, 0600);
  msg_remove_queue ($msg_id);
}

ob_flush();
flush();

?>

