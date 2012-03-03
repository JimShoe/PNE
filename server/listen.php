<?php
  // include stuff like register
  include("functions.php");                                           // inicludes our common functions

  // Do some checks first
  if(!$_GET)return;                                                  // must be GET
  if(!isset($_GET['user']))return;                                   // must have user in GET
  if(!isset($_GET['pass']))return;                                   // must have pass in GET
  if(!register($_GET['user'], $_GET['pass']))return;                // user and pass are good
  if(user_active($_GET['user']))return;                              // user connot be active
  
  // set user to access config options
  $user = $_GET['user'];                                             // save user

  ob_implicit_flush(true);                                            // flush before before printing to it
  $MSGKEY = $ini[$user]['queue_id'];                                  // user's message queue
  $option_receive = MSG_IPC_NOWAIT;                                   // no blocking
  $msg_id = msg_get_queue ($MSGKEY, 0600);                            // queue permissiions
  
  ignore_user_abort(true);                                            // ignore abort, will test for
  set_time_limit(0);                                                  // let it run forver

  while (1) {                                                         // run forever
    if (msg_receive ($msg_id, 1, $msg_type, 16384, 
        $msg, true, $option_receive, $msg_error)) {                 // start receiving messages
      print "$msg\n";                                               // print if received message
    }
    print "\n";                                                     // keep alive & status check
    if (connection_status() != CONNECTION_NORMAL){                  // check for connection
      die;                                                          // kill if no connection
    }
    msg_set_queue ($msg_id, array ('msg_ctime'=>time()));           //update the ctime in the queue though I think this doesn't actually use time()
    ob_flush();                                                     // flush
    flush();                                                        // flush
    sleep(1);                                                       // sleep 1 sec
  }
?>
