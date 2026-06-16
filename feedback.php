<?php
$conn = new mysqli("localhost","root","","eco");

$name = isset($_POST['name']) ? $_POST['name'] : '';
$rating = isset($_POST['rating']) ? $_POST['rating'] : '';
$drawback_option = isset($_POST['drawback_option']) ? $_POST['drawback_option'] : '';
$drawback_text = isset($_POST['drawback_text']) ? $_POST['drawback_text'] : '';

$sql = "INSERT INTO feedback (name, rating, drawback_option, drawback_text)
VALUES ('$name','$rating','$drawback_option','$drawback_text')";

if($conn->query($sql)){
    echo "
    <!DOCTYPE html>
    <html>
    <head>
    <title>Feedback Submitted</title>

    <link href='https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap' rel='stylesheet'>

    <style>
    *{
        margin:0;
        padding:0;
        box-sizing:border-box;
        font-family:'Poppins', sans-serif;
    }

    /* 🌌 Animated Background */
    body{
        height:100vh;
        display:flex;
        justify-content:center;
        align-items:center;
        background:linear-gradient(270deg,#0f2027,#203a43,#2c5364);
        background-size:600% 600%;
        animation:bgMove 10s ease infinite;
        color:white;
    }

    @keyframes bgMove{
        0%{background-position:0% 50%;}
        50%{background-position:100% 50%;}
        100%{background-position:0% 50%;}
    }

    /* ✨ Glow circles */
    .circle{
        position:absolute;
        border-radius:50%;
        filter:blur(60px);
        opacity:0.4;
    }
    .circle1{width:200px;height:200px;background:#00ffcc;top:10%;left:10%;}
    .circle2{width:150px;height:150px;background:#66ff66;bottom:10%;right:10%;}

    /* 💎 Glass Box */
    .box{
        position:relative;
        background:rgba(255,255,255,0.08);
        padding:40px;
        border-radius:20px;
        text-align:center;
        backdrop-filter:blur(15px);
        box-shadow:0 10px 50px rgba(0,0,0,0.7);
        animation:fadeIn 1s ease;
    }

    @keyframes fadeIn{
        from{opacity:0; transform:scale(0.8);}
        to{opacity:1; transform:scale(1);}
    }

    .tick{
        font-size:60px;
        color:#00ffcc;
        margin-bottom:10px;
    }

    h2{
        color:#00ffcc;
        margin-bottom:10px;
    }

    p{
        margin-bottom:20px;
        opacity:0.9;
    }

    /* Buttons */
    button{
        padding:12px 25px;
        border:none;
        border-radius:25px;
        background:#00ffcc;
        color:black;
        font-weight:bold;
        cursor:pointer;
        transition:0.3s;
    }

    button:hover{
        transform:scale(1.1);
        box-shadow:0 0 15px #00ffcc;
    }
    </style>

    </head>

    <body>

    <div class='circle circle1'></div>
    <div class='circle circle2'></div>

    <div class='box'>

        <div class='tick'>✔</div>

        <h2>Feedback Submitted</h2>
        <p>Thank you for your valuable feedback! 💬</p>

        <button onclick=\"window.location.href='dashboard.html'\">
            ⬅ Go Back
        </button>

    </div>

    </body>
    </html>
    ";
}else{
    echo "Error";
}
?>