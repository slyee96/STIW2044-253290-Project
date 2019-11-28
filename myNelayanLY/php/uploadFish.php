<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['Email'];
$fishtitle = $_POST['fishtitle'];
$fishdescription = $_POST['fishdescription'];
$fishprice = $_POST['fishprice'];
$latitude = $_POST['fishlatitudee'];
$longitude = $_POST['fishlongitude'];
$encoded_string = $_POST["encoded_string"];
$wallet = $_POST['Wallet'];
$rating = $_POST['fishrating'];
$decoded_string = base64_decode($encoded_string);
$mydate =  date('dmYhis');
$imagename = $mydate.'-'.$email;

$sqlinsert = "INSERT INTO Fish(FishTittle,FishOwner,FishDescription,FishPrice,FishImage,Latitude,Longitude, Rating) VALUES ('$fishtitle','$email','$fishdescription','$fishprice','$imagename','$latitude','$longitude','$rating')";

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