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
$wallet = $_POST['wallet'];
$decoded_string = base64_decode($encoded_string);
$mydate =  date('dmYhis');
$imagename = $mydate.'-'.$email;

$sqlinsert = "INSERT INTO Fish(FishTittle,FishOwner,FishDescription,FishPrice,FishImage,Latitude,Longitude) VALUES ('$fishtitle','$email','$fishdescription','$fishprice','$imagename','$latitude','$longitude')";

if ($wallet>0){
    if ($conn->query($sqlinsert) === TRUE) {
        $path = '../images/'.$imagename.'.jpg';
        file_put_contents($path, $decoded_string);
        $newwallet = $wallet - 1;
        $sqlwallet = "UPDATE User SET Wallet = '$newwallet' WHERE Email = '$email'";
        $conn->query($sqlwallet);
        echo "success";
    } else {
        echo "failed";
    }
}else{
    echo "low wallet";
}

?>