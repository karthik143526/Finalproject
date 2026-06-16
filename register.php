<?php
$conn = new mysqli("localhost", "root", "", "eco");

if ($conn->connect_error) {
    die("Connection Failed: " . $conn->connect_error);
}

$message = "";
$subtext = "";
$success = false;

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $name = isset($_POST['name']) ? trim($_POST['name']) : '';
    $email = isset($_POST['email']) ? trim($_POST['email']) : '';
    $password = isset($_POST['password']) ? $_POST['password'] : '';
    $confirm_password = isset($_POST['confirm_password']) ? $_POST['confirm_password'] : '';

    if (empty($password) || empty($confirm_password)) {
        $message = "❌ Password fields cannot be empty";
        $subtext = "Please fill in all fields.";
    } elseif ($password != $confirm_password) {
        $message = "❌ Passwords do not match";
        $subtext = "Please check your password and try again.";
    } elseif (
        strlen($password) < 8 ||
        !preg_match('/[A-Z]/', $password) ||
        !preg_match('/[0-9]/', $password) ||
        !preg_match('/[^A-Za-z0-9]/', $password)
    ) {
        $message = "❌ Password is too weak";
        $subtext = "Use at least 8 characters with an uppercase letter, a number, and a symbol.";
    } else {

        $hashed_password = password_hash($password, PASSWORD_DEFAULT);

        $check = "SELECT * FROM users WHERE email='$email'";
        $result = $conn->query($check);

        if ($result->num_rows > 0) {
            $message = "⚠ Email already registered";
            $subtext = "Try logging in instead.";
        } else {

            $sql = "INSERT INTO users (name, email, password) 
                    VALUES ('$name', '$email', '$hashed_password')";

            if ($conn->query($sql) === TRUE) {
                $message = " Successfully Registered!";
                $subtext = "Welcome $name 🎉 Your account is ready.";
                $success = true;
            } else {
                $message = "❌ Error occurred";
                $subtext = $conn->error;
            }
        }
    }
}

$conn->close();
?>

<!DOCTYPE html>
<html>
<head>
<title>Registration Status</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

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

/* 🔥 Layout */
.wrapper{
    display:flex;
    width:90%;
    max-width:1100px;
    justify-content:space-between;
    align-items:center;
}

/* LEFT */
.left{
    width:30%;
}

.left h1{
    margin-bottom:15px;
}

.left p{
    line-height:1.6;
}

/* CENTER */
.box{
    background:rgba(255,255,255,0.1);
    padding:40px;
    border-radius:20px;
    text-align:center;
    backdrop-filter:blur(15px);
    box-shadow:0 10px 40px rgba(0,0,0,0.5);
}

.tick{
    font-size:50px;
    margin-bottom:10px;
}

/* RIGHT */
.right{
    width:30%;
    text-align:center;
}

.right img{
    width:100%;
    border-radius:15px;
    margin-bottom:10px;
}

/* BUTTON */
button{
    margin:10px;
    padding:12px 25px;
    border:none;
    border-radius:25px;
    cursor:pointer;
    font-weight:bold;
}

.login{
    background:#00ffcc;
    color:black;
}

.back{
    background:#333;
    color:white;
}

button:hover{
    transform:scale(1.1);
}

/* MOBILE */
@media(max-width:900px){
    .wrapper{
        flex-direction:column;
        gap:20px;
    }
    .left,.right{
        width:100%;
        text-align:center;
    }
}
</style>

</head>

<body>

<div class="wrapper">

    <!-- LEFT -->
    <div class="left">
        <h1>🌱 EcoWaste</h1>
        <p>
            Smart waste management system for cleaner cities.  
            Manage pickups and track your requests easily.
        </p>
    </div>

    <!-- CENTER -->
    <div class="box">
        <div class="tick"><?php echo $success ? "✔" : "⚠"; ?></div>

        <h2><?php echo $message; ?></h2>
        <p><?php echo $subtext; ?></p>

        <button class="login" onclick="window.location.href='login.html'">
            Login Here
        </button>

        <button class="back" onclick="window.location.href='register.html'">
            Go Back
        </button>
    </div>

    <!-- RIGHT -->
    <div class="right">
        <img src="https://images.unsplash.com/photo-1509395176047-4a66953fd231">
        <img src="https://images.unsplash.com/photo-1581578731548-c64695cc6952">
    </div>

</div>

</body>
</html>