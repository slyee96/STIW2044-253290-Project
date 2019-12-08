<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];

$sql = "UPDATE User SET Verify = '1' WHERE Email = '$email'";
if ($conn->query($sql) === TRUE) {
    echo "success";
} else {
    echo "error";
}
$conn->close();
?>
