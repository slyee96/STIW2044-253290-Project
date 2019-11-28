<?php
//error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['Name'];
$phone = $_POST['Phone'];
$email = $_POST['Email'];
$password = sha1($_POST['Password']);
$radius = $_POST['Radius'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

$sqlinsert = "INSERT INTO User(Name,Phone,Email,Password,Verify) VALUES ('$name','$phone','$email','$password','0')";
if ($conn->query($sqlinsert) === TRUE) {
    $path = '../profile/'.$email.'.jpg';
    file_put_contents($path, $decoded_string);
    sendEmail($email);
    echo "Success for Registration";
} else {
    echo "Failed for Registration";
}
function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for Register'; 
    $message = 'http://myondb.com/myNelayanLY/php/verify.php?email='.$useremail;
    $headers = 'From: noreply@myNelayanLY.com.my' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}
?>
