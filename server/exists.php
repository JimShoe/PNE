<?php
include("functions.php");

ob_implicit_flush(true);
foreach (array_keys($ini) as $user){ 
  $key = $ini[$user]['queue_id']; // user's message queue
  if (msg_queue_exists($key)){
    $queue = msg_get_queue($key);
    echo $key,'::Exists',"\n"; 
    $queue_status = msg_stat_queue($queue);
    echo '  msg_perm.uid=>'.$queue_status['msg_perm.uid']."\n";
    echo '  msg_perm.gid=>'.$queue_status['msg_perm.gid']."\n";
    echo '  msg_perm.mode=>'.$queue_status['msg_perm.mode']."\n";
    echo '  msg_stime=>'.$queue_status['msg_stime']."\n";
    echo '  msg_rtime=>'.$queue_status['msg_rtime']."\n";
    echo '  msg_ctime=>'.$queue_status['msg_ctime']."\n";
    echo '  msg_qnum=>'.$queue_status['msg_qnum']."\n";
    echo '  msg_qbytes=>'.$queue_status['msg_qbytes']."\n";
    echo '  msg_lspid=>'.$queue_status['msg_lspid']."\n";
    echo '  msg_lrpid=>'.$queue_status['msg_lrpid']."\n";
   }
ob_flush();
flush();
}
?>

