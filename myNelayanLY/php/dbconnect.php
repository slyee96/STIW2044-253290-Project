<?php
$servername = "localhost";
$username 	= "myondbco_mynelayan2admin";
$password 	= "S0Uyshkan^3g";
$dbname 	= "myondbco_mynelayan2";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>