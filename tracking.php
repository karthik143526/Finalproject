<?php
$conn = new mysqli("localhost","root","","eco");

$id = isset($_POST['tracking_id']) ? $_POST['tracking_id'] : '';

$result = $conn->query("SELECT * FROM requests WHERE tracking_id='$id'");

echo "
<!DOCTYPE html>
<html>
<head>
<title>Tracking Result</title>

<link href='https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap' rel='stylesheet'>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Poppins', sans-serif;
}

/* 🌌 Background */
body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:linear-gradient(270deg,#0f2027,#203a43,#2c5364),url('3.jpg');
    background-size:600% 600%;
    animation:bgMove 10s ease infinite;
    color:white;
}

@keyframes bgMove{
    0%{background-position:0% 50%;}
    50%{background-position:100% 50%;}
    100%{background-position:0% 50%;}
}

/* 💎 Box */
.box{
    background:rgba(255,255,255,0.08);
    padding:40px;
    border-radius:20px;
    text-align:center;
    width:350px;
    backdrop-filter:blur(15px);
    box-shadow:0 10px 40px rgba(0,0,0,0.6);
}

/* Title */
h2{
    color:#00ffcc;
    margin-bottom:15px;
}

/* Text */
p{
    margin:8px 0;
}

/* Button */
button{
    margin-top:20px;
    padding:12px 25px;
    border:none;
    border-radius:25px;
    background:#00ffcc;
    color:black;
    font-weight:bold;
    cursor:pointer;
}
</style>
</head>

<body>

<div class='box'>
";

if($result->num_rows > 0){
    $row = $result->fetch_assoc();

    echo "<h2>📍 Status: ".$row['status']."</h2>";
    echo "<p><b>Name:</b> ".$row['name']."</p>";
    echo "<p><b>Date:</b> ".$row['pickup_date']."</p>";

} else {
    echo "<h2>No request found</h2>";
}

echo "
<button onclick=\"window.location.href='tracking.html'\">⬅ Back</button>
</div>
</body>
</html>
";
?>