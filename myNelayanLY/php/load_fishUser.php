<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM Fish WHERE FishOwner = '$email'  ORDER BY FishID DESC";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["fishes"] = array();
    while ($row = $result ->fetch_assoc()){
        $fishlist = array();
        $fishlist[fishid] = $row["FishID"];
        $fishlist[fishtitle] = $row["FishTittle"];
        $fishlist[fishowner] = $row["FishOwner"];
        $fishlist[fishdescption] = $row["FishDescription"];
        $fishlist[fishprice] = $row["FishPrice"];
        $fishlist[fishtime] = date_format(date_create($row["FishCatchTime"]), 'd/m/Y h:i:s');
        $fishlist[fishimage] = $row["FishImage"];
        $fishlist[fishlatitude] = $row["Latitude"];
        $fishlist[fishlongitude] = $row["Longitude"];
        $fishlist[fishrating] = $row["Rating"];
        array_push($response["fishes"], $fishlist);   
    }
    echo json_encode($response);
}else{
    echo "nodata";
}


?>