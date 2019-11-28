<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['Email'];
$latitude = $_POST['fishlatitude'];
$longitude = $_POST['fishlongitude'];

$sql = "SELECT * FROM Fish WHERE FishAccepted IS NULL ORDER BY FishID DESC";

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
        $fishlist[fishtime] = date_format(date_create($row["pFishCatchTime"]), 'd/m/Y h:i:s');
        $fishlist[fishimage] = $row["FishImage"];
        $fishlist[fishlatitude] = $row["Latitude"];
        $fishlist[fishlongitude] = $row["Longitude"];
        $fishlist[km] = distance($latitude,$longitude,$row["Latitude"],$row["Longitude"]);
        $fishlist[fishrating] = $row["Rating"];
        //$fishlist[radius] = $row["LATITUDE"];
        if (distance($latitude,$longitude,$row["Latitude"],$row["Longitude"])<$radius){
            array_push($response["fishes"], $fishlist);    
        }
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

function distance($lat1, $lon1, $lat2, $lon2) {
   $pi80 = M_PI / 180;
    $lat1 *= $pi80;
    $lon1 *= $pi80;
    $lat2 *= $pi80;
    $lon2 *= $pi80;

    $r = 6372.797; // mean radius of Earth in km
    $dlat = $lat2 - $lat1;
    $dlon = $lon2 - $lon1;
    $a = sin($dlat / 2) * sin($dlat / 2) + cos($lat1) * cos($lat2) * sin($dlon / 2) * sin($dlon / 2);
    $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
    $km = $r * $c;

    //echo '<br/>'.$km;
    return $km;
}

?>