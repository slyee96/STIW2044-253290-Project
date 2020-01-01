<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$fishtitle = $_POST['fishtittle'];
$fishdescription = $_POST['fishdescription'];
$fishprice = $_POST['fishprice'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$encoded_string = $_POST["encoded_string"];
$credit = $_POST['credit'];
$decoded_string = base64_decode($encoded_string);
$mydate =  date('dmYhis');
$imagename = $mydate.'-'.$email;

$sqlinsert = "INSERT INTO FISH(FISHTITLE,FISHOWNER,FISHDESCRIPTION,FISHPRICE,FISHIMAGE,LATITUDE,LONGITUDE) VALUES ('$fishtitle','$email','$fishdescription','$fishprice','$imagename','$latitude','$longitude')";

if ($credit>0){
    if ($conn->query($sqlinsert) === TRUE) {
        $path = '../images/'.$imagename.'.jpg';
        file_put_contents($path, $decoded_string);
        $newcredit = $credit - 1;
        $sqlcredit = "UPDATE User SET Credit = '$newcredit' WHERE Email = '$email'";
        $conn->query($sqlcredit);
        echo "success";
    } else {
        echo "failed";
    }
}else{
    echo "low credit";
}

?>