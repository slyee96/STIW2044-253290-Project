<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$name = $_POST['name'];
$password = $_POST['password'];
$phone = $_POST['phone'];

$usersql = "SELECT * FROM User WHERE Email = '$email'";

if (isset($name) && (!empty($name))){
    $sql = "UPDATE User SET Name = '$name' WHERE Email = '$email'";
}
if (isset($password) && (!empty($password))){
    $sql = "UPDATE User SET Password = sha1($password) WHERE Email = '$email'";
}
if (isset($phone) && (!empty($phone))){
    $sql = "UPDATE User SET Phone = '$phone' WHERE Email = '$email'";
}

if ($conn->query($sql) === TRUE) {
    $result = $conn->query($usersql);
if ($result->num_rows > 0) {
        while ($row = $result ->fetch_assoc()){
        echo "success,".$row["Name"].",".$row["Phone"].",".$row["Email"].",".$row["Wallet"].",".$row["Rating"].",".$row["date"];
        }
    }else{
        echo "failed,null,null,null,null,null,null";
    }
} else {
    echo "error";
}

$conn->close();
?>
