<?php
$conn = new mysqli("localhost", "root", "", "eco");

$email = isset($_POST['email']) ? trim($_POST['email']) : '';

if (!$email) {
    echo "Error: Email is required.";
    exit();
}

$stmt = $conn->prepare("SELECT * FROM users WHERE email=?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {

    echo "
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset='UTF-8'>
    <title>Reset Password</title>

    <link href='https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap' rel='stylesheet'>

    <style>
    *{
        margin:0;
        padding:0;
        box-sizing:border-box;
        font-family:Poppins;
    }

    body{
        display:flex;
        justify-content:center;
        align-items:center;
        height:100vh;
        background:linear-gradient(270deg,#0f2027,#203a43,#2c5364);
        background-size:600% 600%;
        animation:bgMove 8s ease infinite;
        color:white;
    }

    @keyframes bgMove{
        0%{background-position:0% 50%;}
        50%{background-position:100% 50%;}
        100%{background-position:0% 50%;}
    }

    .box{
        background:rgba(255,255,255,0.1);
        padding:40px;
        border-radius:20px;
        text-align:center;
        width:340px;
        backdrop-filter:blur(15px);
        box-shadow:0 10px 40px rgba(0,0,0,0.6);
    }

    h2{
        color:#00ffcc;
        margin-bottom:15px;
    }

    input{
        width:100%;
        padding:12px;
        margin:10px 0;
        border:none;
        border-radius:10px;
        outline:none;
    }

    button{
        width:100%;
        padding:12px;
        margin-top:10px;
        border:none;
        border-radius:25px;
        cursor:pointer;
        font-weight:bold;
        transition:0.3s;
    }

    .update{
        background:#00ff99;
        color:black;
    }

    .back{
        background:#333;
        color:white;
    }

    button:hover{
        transform:scale(1.05);
        box-shadow:0 0 15px #00ffcc;
    }

    .rule{
        font-size:12px;
        color:#ddd;
        margin-top:10px;
        text-align:left;
    }
    </style>

    </head>

    <body>

    <div class='box'>
        <h2>🔐 Reset Password</h2>

        <form action='reset_password.php' method='POST'>
            <input type='hidden' name='email' value='$email'>

            <input
                type='password'
                name='new_password'
                placeholder='Enter New Password'
                pattern='^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&]).{8,}$'
                title='Minimum 8 characters, one uppercase, one lowercase, one number and one special character'
                required>

            <div class='rule'>
                Password must contain:<br>
                ✔ 8+ characters<br>
                ✔ One uppercase letter<br>
                ✔ One lowercase letter<br>
                ✔ One number<br>
                ✔ One special character
            </div>

            <button type='submit' class='update'>
                Update Password
            </button>
        </form>

        <button class='back'
        onclick=\"window.location.href='forgot_password.html'\">
            ⬅ Back
        </button>

    </div>

    </body>
    </html>
    ";

} else {

    echo "
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset='UTF-8'>
    <title>Email Not Found</title>

    <style>
    body{
        display:flex;
        justify-content:center;
        align-items:center;
        height:100vh;
        background:#b30000;
        color:white;
        font-family:Poppins;
    }

    .box{
        background:rgba(255,255,255,0.1);
        padding:40px;
        border-radius:20px;
        text-align:center;
        width:340px;
    }

    button{
        width:100%;
        padding:12px;
        margin-top:10px;
        border:none;
        border-radius:25px;
        cursor:pointer;
    }
    </style>

    </head>

    <body>

    <div class='box'>
        <h2>❌ Email Not Found</h2>
        <p>The entered email does not exist.</p>

        <button onclick=\"window.location.href='forgot_password.html'\">
            Try Again
        </button>

        <button onclick=\"window.location.href='login.html'\">
            Go Back
        </button>
    </div>

    </body>
    </html>
    ";
}
?>