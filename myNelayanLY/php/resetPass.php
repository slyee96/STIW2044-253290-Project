<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$temppass = $_POST['temPassword'];
$temppasssha = sha1($temppass);
$newpass = $_POST['newPassword'];
$newpasssha = sha1($newpass);

$sqls = "SELECT * FROM User WHERE Email ='$email' AND Password ='$temppasssha' AND Verify='1'";
$result = $conn->query($sqls);

if($result->num_rows>0){
    $sql = "UPDATE User SET Password='$newpasssha' WHERE Email = '$email'";
    if($conn->query($sql) === TRUE){
        echo "Success";
    }
}else{
    echo "Incorrect Password";
}