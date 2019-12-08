<?php
error_reporting(0);
include_once("dbconnect.php");

$name = $_POST['name'];
$phone = $_POST['phone'];
$email = $_POST['email'];
$password = $_POST['password'];

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
        echo "success,".$row["Name"].",".$row["Phone"].",".$row["Email"].",".$row["Radius"].",".$row["Wallet"].",".$row["Rating"].",".$row["Date"];
        }
    }else{
        echo "failed,null,null,null,null,null,null,null";
    }
} else {
    echo "error";
}

$conn->close();
?>
