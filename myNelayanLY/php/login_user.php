<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = $_POST['password'];
$passwordsha = sha1($password);

$sql = "SELECT * FROM User WHERE Email = '$email' AND Password = '$passwordsha' AND Verify ='1'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo "success,".$row["Name"].",".$row["Phone"].",".$row["Email"].",".$row["Credit"].",".$row["Date"];
    }
}else{
    echo "failed,null,null,null,null,null";
}