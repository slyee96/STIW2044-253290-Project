<?php
error_reporting(0);
include_once("dbconnect.php");
$fishid = $_POST['fishid'];
$email = $_POST['email'];
$credit = $_POST['credit'];

$sql = "UPDATE FISH SET FISHACCEPTED = '$email' WHERE FISHID = '$fishid'";
if ($conn->query($sql) === TRUE) {
    $newcredit = $credit - 1;
    $sqlcredit = "UPDATE User SET Credit = '$newcredit' WHERE Email = '$email'";
    $conn->query($sqlcredit);
    echo "success";
} else {
    echo "error";
}

$conn->close();
?>
