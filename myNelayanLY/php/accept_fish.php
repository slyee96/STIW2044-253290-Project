<?php
error_reporting(0);
include_once("dbconnect.php");
$fishid = $_POST['FishID'];
$email = $_POST['Email'];
$wallet = $_POST['Wallet'];

$sql = "UPDATE Fish SET FishAccepted = '$email'  WHERE FishID = '$fishid'";
if ($conn->query($sql) === TRUE) {
    $newwallet = $wallet - 1;
    $sqlwallet = "UPDATE User SET Wallet = '$newwallet' WHERE Email = '$email'";
    $conn->query($sqlwallet);
    echo "success";
} else {
    echo "error";
}

$conn->close();
?>
