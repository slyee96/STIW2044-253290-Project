<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['Email'];

$sql = "UPDATE User SET Verify = '1' WHERE User.Email = '$email'";
if ($conn->query($sql) === TRUE) {
    echo "success";
} else {
    echo "error";
}
$conn->close();
?>
