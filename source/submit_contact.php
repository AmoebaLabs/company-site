<?php
$email_to = "sayhi@amoe.ba";
$email_subject = "[ContactUs Submission] Web request from {$_POST['name']}";

$email_from = "noreply@amoe.ba";

function died($error) {
    header('HTTP/1.1 400 Bad Request');
    echo $error;
    die();
}

// validation expected data exists
if( !isset($_POST['name']) ||
    !isset($_POST['email']) ||
    !isset($_POST['company']) ||
    !isset($_POST['message'])) {
    died('We are sorry, but there appears to be a problem with the form you submitted.');
}

$contact_name = $_POST['name']; // required
$contact_email = $_POST['email']; // required
$contact_company = $_POST['company']; // required
$contact_message = $_POST['message']; // required

$error_message = "";
$email_exp = '/^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/';
if(!preg_match($email_exp,$contact_email)) {
    $error_message .= 'The email address you entered does not appear to be valid.';
}

if (strlen($contact_name) < 1) {
    $error_message .= 'The name you entered does not appear to be valid.';
}
if (strlen($contact_message) < 1) {
    $error_message .= 'The message you entered does not appear to be valid.';
}
if (strlen($error_message) > 0) {
    died($error_message);
}

$email_message = "Form details below.\n\n";

function clean_string($string) {
  $bad = array("content-type","bcc:","to:","cc:","href");
  return str_replace($bad,"",$string);
}

$email_message .= "Name: ".clean_string($contact_name)."\n";
$email_message .= "Email: ".clean_string($contact_email)."\n";
$email_message .= "Company: ".clean_string($contact_company)."\n";
$email_message .= "Message: ".clean_string($contact_message)."\n";


// create email headers
$headers = 'From: '.$email_from."\r\n".
'Reply-To: '.$contact_email."\r\n" .
'X-Mailer: PHP/' . phpversion();
@mail($email_to, $email_subject, $email_message, $headers);

header('HTTP/1.1 202 Accepted');
?>