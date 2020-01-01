<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM FISH WHERE FISHOWNER = '$email'  ORDER BY FISHID DESC";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["fishes"] = array();
    while ($row = $result ->fetch_assoc()){
        $fishlist = array();
        $fishlist[fishid] = $row["FISHID"];
        $fishlist[fishtitle] = $row["FISHTITLE"];
        $fishlist[fishowner] = $row["FISHOWNER"];
        $fishlist[fishdescption] = $row["FISHDESCRIPTION"];
        $fishlist[fishprice] = $row["FISHPRICE"];
        $fishlist[fishtime] = date_format(date_create($row["FISHTIME"]), 'd/m/Y h:i:s');
        $fishlist[fishimage] = $row["FISHIMAGE"];
        $fishlist[fishlatitude] = $row["LATITUDE"];
        $fishlist[fishlongitude] = $row["LONGITUDE"];
        array_push($response["fishes"], $fishlist);   
    }
    echo json_encode($response);
}else{
    echo "nodata";
}


?>