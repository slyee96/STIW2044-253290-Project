<?php
error_reporting(0);
include_once("dbconnect.php");
$fishid = $_POST['FishID'];
$sql     = "DELETE FROM Fish WHERE FishID = $fishid";
    if ($conn->query($sql) === TRUE){
        echo "success";
    }else {
        echo "failed";
    }

$conn->close();
?>