<?php
$conn = new mysqli("localhost","root","","eco");

$email = $_POST['email'];
$new_password = password_hash($_POST['new_password'], PASSWORD_DEFAULT);

$conn->query("UPDATE users SET password='$new_password' WHERE email='$email'");

echo "
<!DOCTYPE html>
<html>
<head>
<title>Password Updated</title>

<link href='https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap' rel='stylesheet'>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Poppins;
}

/* 🌌 Background */
body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:linear-gradient(270deg,#00ff99,#009966,#00ccff);
    background-size:600% 600%;
    animation:bgMove 8s ease infinite;
    color:white;
}

@keyframes bgMove{
    0%{background-position:0% 50%;}
    50%{background-position:100% 50%;}
    100%{background-position:0% 50%;}
}

/* 💎 Box */
.box{
    background:rgba(255,255,255,0.1);
    padding:50px;
    border-radius:20px;
    text-align:center;
    backdrop-filter:blur(15px);
    box-shadow:0 10px 40px rgba(0,0,0,0.5);
}

/* ✔ Tick */
.tick{
    font-size:60px;
    margin-bottom:15px;
    animation:pop 0.5s ease;
}

@keyframes pop{
    0%{transform:scale(0);}
    100%{transform:scale(1);}
}

h2{
    margin-bottom:20px;
}

/* BUTTON */
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
    box-shadow:0 0 15px white;
}
</style>

</head>

<body>

<div class='box'>

<div class='tick'>✔</div>

<h2>Password Updated Successfully!</h2>

<button onclick=\"window.location.href='login.html'\">
    Login Now 🔐
</button>

</div>

</body>
</html>
";
?>