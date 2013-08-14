<?php
  // include stuff like register
  include("functions.php");                                           // inclues our functions

  // Do some checks first
  if(!$_GET)return;                                                  // must be GET
  if(!isset($_GET['user']))return;                                   // must have user in GET
  if(!isset($_GET['pass']))return;                                   // must have pass in GET
  if(!isset($_GET['msg_type']))return;                               // must have msg_type in GET
  if(!isset($_GET['msg']))return;                                    // must have msg in GET
  if(!register($_GET['user'], $_GET['pass']))return;                 // user and pass are good

  $msg_type = $_GET['msg_type'];                                     // copy GET to msg_type
  $msg = $_GET['msg'];                                               // copy GET to msg
  $delivered = FALSE;

  // check what users get this message
  foreach (array_keys($ini) as $user){                               // loop though users
    if(!preg_match($ini[$user]['subscribe'], $msg_type))continue;    // check if user is subscribed
    if(!user_active($user))continue;                                 // check if user is active
    send_msg($user, $msg);                                           // send message
    $delivered = TRUE;
  } 
  if(!$delivered) send_to_phone($msg);                               // send to pushover

function send_msg($user, $msg){
  global $ini;                                                       // get ini
  $MSGKEY = $ini[$user]['queue_id'];                                 // user's message queue
  $msg_id = msg_get_queue ($MSGKEY, 0600);                           // open the queue
  if (msg_send ($msg_id, 1, $msg, true, true, $msg_err))             // push message in queue
    print "200\n";                                                   // message pushed OK
  else
    print "400\n";                                                   // something is wrong
}

function send_to_phone($msg){
  $message=explode("<*>", $msg);
  curl_setopt_array($ch = curl_init(), array(
    CURLOPT_URL => "https://api.pushover.net/1/messages",
    CURLOPT_POSTFIELDS => array(
      "token" => $ini['pushover']['token'],
      "user" => $ini['pushover']['user'],
      "title" => $message[2],
      "message" => $message[3],
    )));
  curl_exec($ch);
  curl_close($ch);
}
?>
